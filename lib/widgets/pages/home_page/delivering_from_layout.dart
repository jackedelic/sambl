import 'dart:async';

import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:sambl/main.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/widgets/pages/available_hawker_center_page/available_hawker_center_page.dart';

class DeliveringFromLayout extends StatelessWidget {

  Future<Null> _displayDialog(BuildContext context) {
    return showDialog<Null>(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: const Text("Missing something..."),
          content: const Text('''Did you forget to select the hawker 
center you want to deliver from? ''',
            style: const TextStyle(
              fontSize: 16.0
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text("Yes I did")
            )
          ],
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new Container(
        padding: new EdgeInsets.symmetric(vertical: 15.0),
        margin: new EdgeInsets.only(bottom: 21.0, top: 22.0),
        width:  screenWidth,
        decoration: new BoxDecoration(
          color: new Color(0x38FFFFFF),
        ),

        child: new Row(
          children: <Widget>[
            // This is the left 'padding' that comes before the 'location'
            new Expanded(
              flex: 1,
              child: new Container(width: 1.0, height: 0.0,),
            ),


            new Flexible(
              flex: 4,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      StoreConnector<AppState, Optional<HawkerCenter>>(
                        converter: (store) => store.state.currentHawkerCenter,
                        builder: (_, currentHawkerCenter) {
                          return Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: () {
                                  print("You tapped 'From: ... ' box, currentHawkerCenter is present: ${currentHawkerCenter.isPresent}");
                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new AvailableHawkerCenterPage())
                                  );
                                },
                                child: new Text("Delivering from: ${currentHawkerCenter.isPresent ? currentHawkerCenter.value.name : "Press to select a hawker center"}",
                                  style: new TextStyle(

                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        
                      )
                    ],
                  ),
                  // This is horizontal divider


                ],
              ),
            ),

            // This is the arrow button
            new StoreConnector<AppState, Optional<HawkerCenter>>(
              converter: (store) => store.state.currentHawkerCenter,
              builder: (_, currentHawkerCenter) {
                return new Flexible(
                  flex: 1,
                  child: new IconButton(
                      icon: new Icon(Icons.chevron_right, color: Colors.white,),
                      onPressed: () {
                        if (currentHawkerCenter.isPresent) {
                          Navigator.of(context).pushNamed("/CreateOpenOrderPage");
                        } else {
                          return _displayDialog(context);
                        }

                      }),
                );
              },

            )


          ],
        )
    );
  }
}
