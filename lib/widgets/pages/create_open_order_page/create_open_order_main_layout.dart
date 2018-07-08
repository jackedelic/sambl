import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/ensure_visible_when_focus.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/order_action.dart';
import 'package:sambl/main.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
import 'package:numberpicker/numberpicker.dart';
/*
* TODO: Create Firebase instance to get the HawkerCentreStall name for the title of the page -> 'Delivering
* TODO: from The Terrace'.
* TODO: Create three TextEditingController widgets each of which corresponds to pickUpPoint, closingTime,
* TODO: and eta in the Firebase.
* */

/// This is the layout that first appear when the user pressed 'Deliver' button on the
/// home page.
class CreateOpenOrderMainLayout extends StatefulWidget {

  /// Constructor that receives the OpenOrder obj.
  CreateOpenOrderMainLayout() {

  }

  @override
  _CreateOpenOrderMainLayoutState createState() =>
      _CreateOpenOrderMainLayoutState();
}

class _CreateOpenOrderMainLayoutState extends State<CreateOpenOrderMainLayout> {
  TextEditingController pickUpPtController = new TextEditingController();


  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        // textField to input location of pickup point
        new Container(
          padding: new EdgeInsets.only(bottom: 10.0, right: 10.0),
          margin: new EdgeInsets.symmetric(horizontal: 20.0),
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
              border: new Border.all(color: MyColors.borderGrey, width: 1.8),
              borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
          child: new Row(
            children: <Widget>[
              // The 'place' icon
              new Padding(
                  padding: new EdgeInsets.symmetric(horizontal: 6.0),
                  child: new Icon(
                    Icons.place,
                    size: 28.0,
                  )),

              // This is the pickup pt textfield. May change to TextFormField for validation purposes.
              new Expanded(
                  child: new ScopedModelDescendant<Info>(
                    rebuildOnChange: false,
                    builder: (context, child, info) {
                      return new TextField(
                          controller: pickUpPtController,
                          decoration: new InputDecoration(
                            labelText: "Pick up point",
                            hintText: "e.g. Tembusu College lobby",
                          ),
                          onChanged: (text) {
                            info.editInfo();
                            },
                        );
                      },

                    ),
                  ),
            ],
          ),
        ),

        // Just some space in btwn the two rows.
        new Padding(padding: new EdgeInsets.all(5.0)),

        // Second row: 'closing time' and 'eta'
        new Container(
          margin: new EdgeInsets.symmetric(horizontal: 20.0),
          child: new Row(
            children: <Widget>[
            // 'Closing time' element
              new Flexible(
                  flex: 2,
                  child: new Container(
                    alignment: Alignment.center,
                    padding: new EdgeInsets.all(10.0 ),
                    decoration: new BoxDecoration(
                        border: new Border.all(
                            color: MyColors.borderGrey, width: 1.8),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(15.0))),
                    // This is the closing time button that shows time picker onpressed.
                    child: new ScopedModelDescendant<Info>(
                      builder: (context, child, info){
                          return new FlatButton(
                            onPressed: () async {
                              print("tapped order closing time");
                              _showTimePicker(Detail.CLOSINGTIME, context, info);
                            },
                            child: new Text(
                              info.closingTime != null ?
                              ("${info.closingTime?.hour ?? DateTime.now().hour}:${info.closingTime.minute  ?? DateTime.now().minute}") :
                              "Order Closing time",
                            ),
                          );
                      }


                    ),

                  ),
              ),

              // Just some space in btwn 'closing time' and 'ETA' elements
              new Padding(padding: new EdgeInsets.all(5.0)),

              // 'ETA' element
              new Flexible(
                  flex: 1,
                  child: new Container(
                      padding: new EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(
                              color: MyColors.borderGrey, width: 1.8),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(15.0))),
                      // This is the eta button that shows time picker on pressed.
                      child: new ScopedModelDescendant<Info>(
                        builder: (context, child, info){
                          return new FlatButton(
                              onPressed: () async {
                                print("tapped order ETA");
                                _showTimePicker(Detail.ETA, context, info);
                              },
                              child: new Text(
                                info.eta != null ?
                                ("${info.eta?.hour ?? DateTime.now().hour}:${info.eta.minute  ?? DateTime.now().minute}") :
                                "eta",
                              )
                          );
                        },
                      ),

                    )
                  )
                ],
              ),
            ),

        // Just some space btwn the two rows
        new Padding(
          padding: new EdgeInsets.symmetric(vertical: 10.0),
        ),

        // The list of nearby places
        new Container(
          height: 160.0,
          child: new ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 40.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          top: new BorderSide(color: Colors.black54))),
                  child: new ListTile(
                    title: new Text("CAPT"),
                  ));
            },
          ),
        ),
      ],
    );
  }

  void _showTimePicker(Detail detail, context, Info info) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
                height: 200.0,
                child: new Row(
                    children: <Widget>[
                      //select hour
                      new Flexible(
                        flex: 1,
                        child: new CupertinoPicker(
                          itemExtent: 40.0,
                          onSelectedItemChanged: (index){
                            print("selected index is $index");
                            switch (detail) {
                              case Detail.CLOSINGTIME:
                                print("time picker for closing time");
                                info.editInfo(closingTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, index, info?.closingTime?.minute ?? DateTime.now().minute));
                                break;
                              case Detail.ETA:
                                print("time picker for eta");
                                info.editInfo(eta: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, index, info?.eta?.minute ?? DateTime.now().minute));
                                break;
                            }
                          },
                          children: Iterable.generate(24, (index){
                            return new Container(
                                padding: new EdgeInsets.all(0.0),
                                margin: new EdgeInsets.only(left: 150.0),
                                child: new Text("$index",
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),

                                )

                            );
                          }).toList(),
                        ),
                      ),

                      // Select minute
                      new Flexible(
                        flex: 1,
                        child: new CupertinoPicker(
                          diameterRatio: 1.0,
                          itemExtent: 40.0,
                          onSelectedItemChanged: (index){
                            print("selected index is $index");
                            switch (detail) {
                              case Detail.CLOSINGTIME:
                                print("info is " + info.toString());
                                info.editInfo(closingTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, info?.closingTime?.hour ?? DateTime.now().hour, index * 15));
                                print("time picker for closing time");
                                break;
                              case Detail.ETA:
                                print("time picker for eta");
                                info.editInfo(eta: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, info?.eta?.hour ?? DateTime.now().hour, index * 15));
                                break;
                            }
                          },
                          children: Iterable.generate(4, (index){
                            return new Container(
                                padding: new EdgeInsets.all(0.0),
                                margin: new EdgeInsets.only(right: 150.0),
                                child: new Text("${index*15}",
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  ),
                                )
                            );
                          }).toList(),
                        ),
                      ),
                    ]
                ),
              );

        }
    );
  }
}

/// label for the time picker
enum Detail {
  CLOSINGTIME, ETA
}