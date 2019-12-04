import 'package:flutter/material.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/addReminder/AddReminderScreen.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/homepage/HomepageScreen.dart';

class HomepageScreenState extends State<HomepageScreen> {
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

    final rightContent = Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Weather reminder',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReminderScreen()),
              );
            },
          ),
        ],
        leading: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                print('ahoj');
              },
            ),
          ],
        )
        ),
      body: Container(
        color: Colors.black12.withOpacity(0.06),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[rightContent],
        ),
      ),
    );
  }
}