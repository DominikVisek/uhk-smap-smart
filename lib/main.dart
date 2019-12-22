import 'dart:async';

import 'package:flutter/material.dart';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:uhk_smap_smart_weather_reminder/model/api/OpenWeatherItem.dart';
import 'package:uhk_smap_smart_weather_reminder/model/database/Reminder.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/homepage/HomepageScreen.dart';
import 'package:uhk_smap_smart_weather_reminder/dataProvider/api/OpenWeatherProvider.dart';

import 'dataProvider/database/DBProvider.dart';

void main() {
  runApp(Homepage());
  configureBackgroundFetch();
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> configureBackgroundFetch() async {
  BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: BackgroundFetchConfig.NETWORK_TYPE_NONE
  ), _onBackgroundFetch).then((int status) {
    print('[BackgroundFetch] configure success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] configure ERROR: $e');
  });
}

void _onBackgroundFetch() async {
  DBProvider db = new DBProvider();
  DateTime current = DateTime.now();
  initNotification();

  for (Reminder reminder in (await db.getReminders())) {
    if (current
        .difference(reminder.getTimeToday())
        .inMinutes < 8) {
      OpenWeatherItem item = await OpenWeatherProvider().getByCoordinates(reminder.latitude.toString(), reminder.longitude.toString());
      double itemTemp = item.temp - 273.15;
      print(itemTemp);
      if (itemTemp > reminder.temperature - 2.0 && itemTemp < reminder.temperature + 2.0) {
        print('yes');
        showNotification(reminder);
      }
    }
  }

  // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  // for taking too long in the background.
  BackgroundFetch.finish();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void initNotification() {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var ios = new IOSInitializationSettings();
  var initSettings = new InitializationSettings(android, ios);
  flutterLocalNotificationsPlugin.initialize(
      initSettings, onSelectNotification: selectNotification);
}

Future selectNotification(String payload) {
  debugPrint('print payload : $payload');
  showDialog(builder: (_) =>
      AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ), context: null,);
}

showNotification(Reminder reminder) async {
  var android = new AndroidNotificationDetails(
      "channelId", "channelName", "channelDescription"
      , priority: Priority.High, importance: Importance.Max);
  var iOS = new IOSNotificationDetails();

  var platform = new NotificationDetails(android, iOS);
  await flutterLocalNotificationsPlugin.show(
      0, 'Weather reminder', 'Weather is prepared for action: ' + reminder.name + ', temperature: ' + reminder.temperature.toString(), platform,
      payload: 'This is my name');
}

class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather reminder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomepageScreen());
  }
}