import 'package:flutter/material.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/homepage/HomepageScreen.dart';

void main() => runApp(Homepage());

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