import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:sambl/widgets/pages/available_hawker_center_page/available_hawker_center_page.dart';
import 'package:sambl/state/app_state.dart';

class OrderLayout extends StatelessWidget {

  Future<Null> _displayDialog(BuildContext context) {
    return showDialog<Null>(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: const Text("Missing something..."),
            content: const Text('''Did you forget to select the hawker 
center you want to order from? ''',
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
        margin: new EdgeInsets.only(bottom: 20.0),
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

                  // This is the 'From ... ' row.
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      StoreConnector<AppState, AppState>( //
                        converter: (store) => store.state,

                        builder: (_, appState) {
                          return new Expanded(
                            child: new GestureDetector(
                              onTap:() {
                                print("You tapped 'From: ... ' box");
                                print("in order layout, openOrderList is ${appState.openOrderList}");
                                Navigator.push(context,
                                    new MaterialPageRoute(builder: (context) => new AvailableHawkerCenterPage())
                                );
                              },
                              child: new Text("Ordering from: ${appState.currentHawkerCenter.isPresent ? appState.currentHawkerCenter.value.name : "Press to select a hawker center"}",
                                style: new TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          );
                        }

                      )
                    ],
                  ),

                  // This is horizontal divider
                  new Container(
                    margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    width: 256.0,
                    height: 1.0,
                    color: Colors.white,
                  ),

                  // This is right below the 'from'
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 5,
                        child: new InkWell(
                          onTap: () {

                          },
                          child: new GestureDetector(
                            onTap:(){},
                            child: new Text("Tap to select your location",
                                style: new TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  color: Colors.white
                                )
                            ),
                          ),
                        ),
                      ),

                      // vertical divider -> Tap to select your location | Use my location
                      new Container(
                        height: 20.0,
                        width: 1.0,
                        color: Colors.white,
                      ),

                      // use my location
                      new Expanded(
                        flex: 2,
                        child: new InkWell(
                          onTap: (){
                            print("you tapped 'use my location'");
                          },
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.place, color: Colors.white,),
                              new Expanded(
                                child: new Text("Use my location",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )


                    ],
                  )
                ],
              ),
            ),

            // This is the arrow button
            new StoreConnector<AppState, Optional<HawkerCenter>>(
              converter: (store) => store.state.currentHawkerCenter,
              builder: (_, currentHawkerCenter) {

                return new Expanded(
                  flex: 1,
                  child: new IconButton(
                      icon: new Icon(Icons.chevron_right, color: Colors.white,),
                      onPressed: () {
                        if (currentHawkerCenter.isPresent) {
                          Navigator.of(context).pushNamed("/OpenOrderListPage");
                        } else {
                          _displayDialog(context);
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
