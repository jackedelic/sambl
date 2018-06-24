import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/order_action.dart'; // Action
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/shared/ensure_visible_when_focus.dart';
/*
* TODO: Create Firebase instance to get the HawkerCentreStall name for the title of the page -> 'Delivering
* TODO: from The Terrace'.
* */


///This page represents the page a user navigates to when he select 'deliver' button in the home page
class DeliverPage extends StatefulWidget {
  @override
  _DeliverPageState createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  FocusNode _focusNode1 = new FocusNode(); // for 'pick up pt' TextField widgets
  FocusNode _focusNode2 = new FocusNode(); // for 'closing time' TextField widgets
  FocusNode _focusNode3 = new FocusNode(); // for 'ETA' TextField widgets
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: new MyAppBar().build(context),
      backgroundColor: MyColors.mainBackground,
      body: new Container(
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        height: MediaQuery.of(context).size.height, // max out the height and then
                                                      // constrained by specified margein
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
          color: Colors.white
        ),
        child: new ListView(
          children: <Widget>[
            // title like -> [Deliver from: FoodClique(NUS)]
            new Container(
              margin: new EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text("Delivering from:",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontSize: 20.0
                      ),

                    ),
                  )
                ],
              ),
            ),

            // textField to input location of pickup point
            new Container(
              padding: new EdgeInsets.all(10.0),
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  border: new Border.all(color: MyColors.borderGrey ,width: 1.8),
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0))
              ),
              child: new Row(
                children: <Widget>[

                  new Icon(Icons.place),
                  // This is the pickup pt textfield. May change to TextFormField for validation purposes.
                  new Expanded(
                      child: new EnsureVisibleWhenFocused(
                        focusNode: _focusNode1,
                        child: new TextField(
                          focusNode: _focusNode1,
                          decoration: new InputDecoration(
                            labelText: "Pick up point",
                            hintText: "e.g. Tembusu College lobby",
                          ),
                        ),
                      )
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // 'Closing time' element
                  new Flexible(
                      flex: 2,
                      child: new Container(
                        padding: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                            border: new Border.all(color: MyColors.borderGrey ,width: 1.8),
                            borderRadius: new BorderRadius.all(new Radius.circular(15.0))
                        ),
                        // This is the closing time textfield. May change to TextFormField for validation purposes.
                        child: new EnsureVisibleWhenFocused(
                          focusNode: _focusNode2,
                          child: new TextField(
                            focusNode: _focusNode2,
                            decoration: new InputDecoration(
                              labelText: "Closing Time",
                            ),
                          ),
                        ),
                      )
                  ),

                  // Just some space in btwn 'closing time' and 'ETA' elements
                  new Padding(padding: new EdgeInsets.all(5.0)),

                  // 'ETA' element
                  new Flexible(
                      flex: 1,
                      child: new Container(
                        padding: new EdgeInsets.all(10.0),
                          decoration: new BoxDecoration(
                              border: new Border.all(color: MyColors.borderGrey ,width: 1.8),
                              borderRadius: new BorderRadius.all(new Radius.circular(15.0))
                          ),
                        // This is the eta textfield. May change to TextFormField for validation purposes.
                          child: new EnsureVisibleWhenFocused(
                            focusNode: _focusNode3,
                            child: new TextField(
                              focusNode: _focusNode3,
                              decoration: new InputDecoration(
                                  labelText: "ETA: "
                              ),
                            ),
                          )
                      )
                  ),

                ],
              ),
            ),

            // Just some space btwn the thw rows
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 20.0),
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
                          top: new BorderSide(color: Colors.black54)
                        )
                      ),
                      child: new ListTile(
                        title: new Text(
                          "CAPT"
                        ),
                      )
                    );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}
