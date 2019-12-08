import 'package:flutter/material.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/addReminder/AddReminderScreen.dart';
import 'package:uhk_smap_smart_weather_reminder/widget/reminder/newReminderForm.dart';

class AddReminderScreenState extends State<AddReminderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double boxWidth;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      boxWidth = ((MediaQuery.of(context).size.width - 60) * 0.75) /
          (MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3);
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'New reminder',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: Colors.black12.withOpacity(0.06),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[NewReminderForm(
            onSubmit: (formData){
              //TODO: SAVE to DATABASE
            },
          )],
        ),
      ),
    );
  }
}
