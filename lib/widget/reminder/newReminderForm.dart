import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:place_picker/place_picker.dart';
import 'package:uhk_smap_smart_weather_reminder/widget/reminder/newReminderForm/formData.dart';

typedef void FormDataCallback(FormData formData);

class NewReminderForm extends StatefulWidget {
  FormDataCallback onSubmit;

  NewReminderForm({@required FormDataCallback onSubmit}){
    this.onSubmit = onSubmit;
  }

  @override
  NewReminderFormState createState() {
    return NewReminderFormState(onSubmit);
  }
}

class NewReminderFormState extends State<NewReminderForm> {
  String _time = "Not set";

  final _formKey = GlobalKey<FormState>();
  FormDataCallback onSubmit;
  FormData _formData;

  NewReminderFormState(FormDataCallback onSubmit) {
    this.onSubmit = onSubmit;
  }

  @override
  void initState() {
    this._formData = new FormData();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        this._formData.time = time;
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
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
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_time",
                                      style: TextStyle(
                                          color: Colors.teal,
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
                                color: Colors.teal,
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
          FlatButton(
            child: Text(
              "Pick Delivery location",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            onPressed: () {
              showPlacePicker();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  this.onSubmit(this._formData);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("API Key")));

            this._formData.location = result;
  }
}
