import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:place_picker/place_picker.dart';
import 'package:uhk_smap_smart_weather_reminder/config/env.dart';
import 'package:uhk_smap_smart_weather_reminder/dataProvider/database/DBProvider.dart';
import 'package:uhk_smap_smart_weather_reminder/model/database/Reminder.dart';
import 'package:uhk_smap_smart_weather_reminder/widget/reminder/newReminderForm/formData.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

typedef Reminder FormDataCallback(FormData formData, Reminder reminder);

class NewReminderForm extends StatefulWidget {
  FormDataCallback preSave;

  NewReminderForm({@required FormDataCallback preSave}) {
    this.preSave = preSave;
  }

  @override
  NewReminderFormState createState() {
    return NewReminderFormState(preSave);
  }
}

class NewReminderFormState extends State<NewReminderForm> {
  String _time = "Not set";
  String _location = "Not set";

  final _formKey = GlobalKey<FormState>();
  FormDataCallback preSave;
  FormData _formData;
  DBProvider _dbProvider;

  TextEditingController temperatureController = new TextEditingController();
  TextEditingController daysBeforeNotifyController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  NewReminderFormState(FormDataCallback onSubmit) {
    this.preSave = onSubmit;
  }

  void setTime(DateTime time) {
    setState(() {
      this._formData.time = time;
    });
  }

  @override
  void initState() {
    this._formData = new FormData();
    this._dbProvider = new DBProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          child: Text('Name',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MAIN_APPLICATION_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: this.nameController,
                        autovalidate: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.weatherSunset, color: MAIN_APPLICATION_COLOR),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          child: Text('Description',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MAIN_APPLICATION_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: this.descriptionController,
                        autovalidate: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.description, color: MAIN_APPLICATION_COLOR),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          child: Text('Temperature',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MAIN_APPLICATION_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: this.temperatureController,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.temperatureCelsius, color: MAIN_APPLICATION_COLOR),
                        ),
                        validator: (input) {
                          final isDigitsOnly = int.tryParse(input);
                          return isDigitsOnly == null
                              ? 'Input needs to be digits only'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          child: Text('Days before notification',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MAIN_APPLICATION_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: this.daysBeforeNotifyController,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.notifications, color: MAIN_APPLICATION_COLOR),
                        ),
                        validator: (input) {
                          final isDigitsOnly = int.tryParse(input);
                          return isDigitsOnly == null
                              ? 'Input needs to be digits only'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          child: Text('Time of remind',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MAIN_APPLICATION_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              onChanged: (time) {
                                this.setTime(time);
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          height: 50,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 18.0,
                                          color: MAIN_APPLICATION_COLOR,
                                        ),
                                        Text(
                                          this._formData.time == null
                                              ? " $_time"
                                              : this._formData.time.hour
                                              .toString() + ':' +
                                              this._formData.time.minute
                                                  .toString() + ':' +
                                              this._formData.time.second.toString(),
                                          style: TextStyle(
                                              color: MAIN_APPLICATION_COLOR,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "  Change",
                                style: TextStyle(
                                    color: MAIN_APPLICATION_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          child: Text('Destination of remind',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MAIN_APPLICATION_COLOR,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          showPlacePicker();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          height: 50,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.gps_fixed,
                                          size: 18.0,
                                          color: MAIN_APPLICATION_COLOR,
                                        ),
                                        Text(
                                          this._formData.location == null
                                              ? " $_location"
                                              : this._formData.location.locality,
                                          style: TextStyle(
                                              color: MAIN_APPLICATION_COLOR,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "  Change",
                                style: TextStyle(
                                    color: MAIN_APPLICATION_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (this._formData.time == null ||
                                this._formData.location == null) {
                              Scaffold.of(context)
                                  .showSnackBar(
                                  SnackBar(content: Text('Data are invalid')));
                              return;
                            }
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(content: Text('Processing Data')));

                            Reminder reminder = new Reminder();
                            reminder.time = this._formData.time.toIso8601String();
                            reminder.longitude = this._formData.location.latLng.longitude;
                            reminder.latitude = this._formData.location.latLng.latitude;
                            reminder.name = this.nameController.text;
                            reminder.description = this.descriptionController.text;
                            reminder.temperature = double.parse(this.temperatureController.text);
                            reminder.daysBeforeNotify = int.parse(this.daysBeforeNotifyController.text);

                            this.preSave(this._formData, reminder);
                            this._dbProvider.createReminder(reminder);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          height: 50,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          child: Text(
                            "Create",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        color: MAIN_APPLICATION_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(GOOGLE_API_KEY)));

    this._formData.location = result;
  }
}
