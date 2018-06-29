import 'package:flutter/material.dart';
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
  FocusNode _focusNode1 = new FocusNode(); // for 'pick up pt' TextField widgets
  FocusNode _focusNode2 = new FocusNode(); // for 'closing time' TextField widgets
  FocusNode _focusNode3 = new FocusNode(); // for 'ETA' TextField widgets

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
                  child: new EnsureVisibleWhenFocused(
                focusNode: _focusNode1,
                child: new TextField(
                  focusNode: _focusNode1,
                  decoration: new InputDecoration(
                    labelText: "Pick up point",
                    hintText: "e.g. Tembusu College lobby",
                  ),
                ),
              )),
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
                    padding: new EdgeInsets.only(
                        bottom: 10.0, left: 10.0, right: 10.0),
                    decoration: new BoxDecoration(
                        border: new Border.all(
                            color: MyColors.borderGrey, width: 1.8),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(15.0))),
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
                  )),

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
                      // This is the eta textfield. May change to TextFormField for validation purposes.
                      child: new EnsureVisibleWhenFocused(
                        focusNode: _focusNode3,
                        child: new TextField(
                          focusNode: _focusNode3,
                          decoration: new InputDecoration(labelText: "ETA: "),
                        ),
                      ))),
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
}
