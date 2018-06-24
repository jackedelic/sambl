import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sambl/widgets/shared/my_button.dart';


class CreateOpenOrderPageDeprecated extends StatefulWidget {
  @override
  _CreateOpenOrderPageDeprecatedState createState() => new _CreateOpenOrderPageDeprecatedState();
}

class _CreateOpenOrderPageDeprecatedState extends State<CreateOpenOrderPageDeprecated> {
  GlobalKey<FormState> _formKey;
  TimeOfDay _chosenClosingTime;
  TimeOfDay _chosenEtaTime;
  String _closingTimeText;
  String _etaTimeText;

  String _pickupPoint;
  String _hawkerName;


  @override
  void initState() {
    super.initState();
    _formKey = new GlobalKey<FormState>();
    _chosenClosingTime = new TimeOfDay.now(); // current time by default
    _chosenEtaTime = add(_chosenClosingTime, minute: 30); // 30 mins from now by default
    _closingTimeText = "${_chosenClosingTime.hour > 12 ? _chosenClosingTime.hour - 12 : _chosenClosingTime.hour}:${_chosenClosingTime.minute} ${_chosenClosingTime.hour > 12 ? 'PM' : 'AM'}";
    _etaTimeText = "${_chosenEtaTime.hour > 12 ? _chosenEtaTime.hour - 12 : _chosenEtaTime.hour}:${_chosenEtaTime.minute} ${_chosenEtaTime.hour > 12 ? 'PM' : 'AM'}";
  }

  // callback for showDatePicker. invoked when user tries to key in date in the form
  Future _chooseClosingTime(BuildContext context) async {
    _chosenClosingTime = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    if (_chosenClosingTime == null) return null;
    setState(() {
      _closingTimeText = "${_chosenClosingTime.hour > 12 ? _chosenClosingTime.hour - 12 : _chosenClosingTime.hour}:${_chosenClosingTime.minute} ${_chosenClosingTime.hour > 12 ? 'PM' : 'AM'}";
      // send this info to datastore
      //...
    });

      return null;
  }

  Future _chooseEtaTime(BuildContext context) async {
    _chosenEtaTime = await showTimePicker(context: context, initialTime: _chosenEtaTime); // initialTime is the default _chosenEtaTime
    if (_chosenEtaTime == null) return null;
    setState(() {
      _etaTimeText = "${_chosenEtaTime.hour > 12 ? _chosenEtaTime.hour - 12 : _chosenEtaTime.hour}:${_chosenEtaTime.minute} ${_chosenEtaTime.hour > 12 ? 'PM' : 'AM'}";
      // send this info to datastore
      // ..
    });
  }

  // If input(pickup pt) are valid, we assign the input(pickup pt) to _pickupPoint
  String _validatePickupPoint(String input) {
    if (input != null) {
      _pickupPoint = input;
      return null;
    } else {
      return "Input is empty";
    }
  }

  // If input(hawker center's name) are valid, we assign the input(hawker center's name) to _hawkerName.
  String _validateHawkerName(String input) {
    if (input != null) {
      _hawkerName = input;
      return null;
    } else {
      return "Input is empty";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
            key: _formKey,

            child: new Column(
              children: <Widget>[
                new TextFormField(
                  autovalidate: true,
                  validator: _validateHawkerName,
                  decoration: new InputDecoration(labelText: "Where you going?", hintText: "e.g. Newton Food Center"),
                ),
                new TextFormField(
                  validator: _validatePickupPoint,
                  decoration: new InputDecoration(labelText: "Food collection point", hintText: "e.g void deck at blk 27"),
                ),

                // closing time picker
                new Row(
                  children: <Widget>[
                    new Expanded(
                      flex: 2,
                      child: new InkWell(
                        child: new Text("close order at $_closingTimeText",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                        onTap: () {
                          _chooseClosingTime(context);
                        },

                      )
                    ),
                    new IconButton(
                      icon: new Icon(Icons.access_time),
                      onPressed: () {
                        _chooseClosingTime(context);
                      }
                    )
                    
                  ],
                ),

                // ETA time picker
                new Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 2,
                        child: new InkWell(
                          child: new Text("Estimated to arrive at $_etaTimeText",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 20.0
                            ),
                          ),
                          onTap: () {
                            _chooseEtaTime(context);
                          },

                        )
                    ),
                    new IconButton(
                        icon: new Icon(Icons.access_time),
                        onPressed: () {
                          _chooseEtaTime(context);
                        }
                    )

                  ],
                ),
                // A button to submit the form
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                       new InkWell(
                         child: new MyButton("Create"),
                         onTap: () {
                           if (_formKey.currentState.validate()) {
                             print("validata!!!!");
                              Firestore.instance.runTransaction((Transaction transaction) async {
                                CollectionReference ref = Firestore.instance.collection("users");
                                await ref.add({
                                  "closing_time": _chosenClosingTime,
                                  "eta":_chosenEtaTime,
                                  "hawker_name": _hawkerName,
                                  "pickup_point" : _pickupPoint
                                });
                              });
                           }
                         },
                        )



                  ],
                )


              ],
            ),

        ),


      ),
    );


  }

}

/// First param is compulsory.
/// Adds two TimeOfDay instances, or add one such instance to some number of hour(s) or minute(s), or add all three of them.
/// If no arguments is provided, it returns the caller itself.
///
/// Returns a [TimeOfDay] instance whose hour ranges from 0..23 and minutes 0..59.
TimeOfDay add(TimeOfDay t, {TimeOfDay otherTime, int hour, int minute}) {
  TimeOfDay resultantTime;
  bool minuteOverflow; // true iff resultant (sum) minute exceeds 59.
  if (otherTime != null) {
    minuteOverflow = false; // true iff resultant (sum) minute exceeds 59.
    resultantTime = new TimeOfDay(
      minute: t.minute + otherTime.minute > 59 ? t.minute + otherTime.minute - 60 + ((minuteOverflow = true) ? 0 : 0) : t.minute + otherTime.minute,
      hour: (minuteOverflow ? (t.hour + otherTime.hour + 1 > 23 ? t.hour + otherTime.hour - 23 : t.hour + otherTime.hour + 1) : (t.hour + otherTime.hour > 23 ? t.hour + otherTime.hour - 24 : t.hour + otherTime.hour)),
    );
  } else {
    resultantTime = t;
  }

  if (hour != null) {
    resultantTime = new TimeOfDay(
      hour: resultantTime.hour + hour > 23 ? resultantTime.hour + hour - 24 : resultantTime.hour + hour,
      minute: resultantTime.minute,
    );
  }
  if (minute != null) {
    minuteOverflow = false; // true iff resultant (sum) minute exceeds 59.
    resultantTime = new TimeOfDay(
      minute: resultantTime.minute + minute > 59 ? resultantTime.minute + minute - 60 + ((minuteOverflow = true) ? 0 : 0) : resultantTime.minute + minute,
      hour: (minuteOverflow ? (resultantTime.hour + (hour ?? 0) + 1 > 23 ? resultantTime.hour + (hour ?? 0) - 23 : resultantTime.hour + (hour ?? 0) + 1) : (resultantTime.hour + (hour ?? 0) > 23 ? resultantTime.hour + (hour ?? 0) - 24 : resultantTime.hour + (hour ?? 0))),
    );
  }
  return resultantTime;
}
