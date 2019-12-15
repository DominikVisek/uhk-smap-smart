import 'package:flutter/material.dart';
import 'package:uhk_smap_smart_weather_reminder/config/env.dart';
import 'package:uhk_smap_smart_weather_reminder/dataProvider/database/DBProvider.dart';
import 'package:uhk_smap_smart_weather_reminder/model/database/Reminder.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/addReminder/AddReminderScreen.dart';
import 'package:uhk_smap_smart_weather_reminder/screen/homepage/HomepageScreen.dart';

class HomepageScreenState extends State<HomepageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Reminder> reminderList;
  DBProvider db = new DBProvider();
  bool loadingInProgress = true;
  double boxWidth;

  initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    List reminderList = await this.db.getReminders();
    this.setLoadingInProgress(false);

    setState(() {
      this.reminderList = reminderList;
    });
  }

  void setLoadingInProgress(bool isInProgress) {
    setState(() {
      loadingInProgress = isInProgress;
    });
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      boxWidth = ((MediaQuery
          .of(context)
          .size
          .width - 60) * 0.75) /
          (MediaQuery
              .of(context)
              .orientation == Orientation.portrait ? 2 : 3);
    });

    Widget barthLoading() {
      return Container(
        padding: EdgeInsets.all(18.0),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(MAIN_APPLICATION_COLOR),
        ),
      );
    }

    Widget listItem(Reminder item) {
      return new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 5.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        height: MediaQuery
            .of(context)
            .orientation == Orientation.portrait ? 150.0 : 170.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.all(20.00),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        item.name != null ? item.name : '-',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Temperature: ' +
                            (item.temperature != null ? item.temperature
                                .toString() : '-'),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Time: ' + (item.time != null ? item.getTime() : '-'),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        item.description != null ? item.description : '-',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: MediaQuery
                  .of(context)
                  .orientation == Orientation.portrait ? 5 : 3,
              child: GestureDetector(
                onTap: () async {
                  await this.db.deleteReminder(item.id);
                  this.loadData();
                },
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 50,
                    ),
                    decoration: BoxDecoration(
                      color: MAIN_APPLICATION_COLOR,
                      border: Border.all(
                        color: MAIN_APPLICATION_COLOR,
                        width: 2.00,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget getBody() {
      if (loadingInProgress) {
        return new Center(
          child: barthLoading(),
        );
      } else {
        return Expanded(
          child: Container(
            child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  new SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    sliver: new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                            (context, index) =>
                            listItem(this.reminderList[index]),
                        childCount: this.reminderList.length,
                      ),
                    ),
                  ),
                ]
            ),
          ),
        );
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: MAIN_APPLICATION_COLOR,
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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReminderScreen()),
              );
              this.loadData();
            },
          ),
        ],
//          leading: Column(
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.edit),
//                color: Colors.white,
//                onPressed: () {
//                },
//              ),
//            ],
//          )
      ),
      body: Container(
        color: Colors.black12.withOpacity(0.06),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[getBody()],
        ),
      ),
    );
  }
}
