import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/shared/my_color.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/main.dart';
/*
This is the page directed when the user wants to see any available food delivery services
(when he pressed 'order' button in the home page).
*/

class OpenOrderListPage extends StatefulWidget {
  @override
  _OpenOrderListPageState createState() => new _OpenOrderListPageState();
}


class _OpenOrderListPageState extends State<OpenOrderListPage> {
  bool timeOut = false; // timeOut becomes true after an arbitrary amount of duration fetching the list.

  Widget _displayCircularProgressIndicator() {
    print("circular progressing in open_order_list_page");
    if (!timeOut) {
      Future.delayed(const Duration(seconds: 10), () {
        timeOut = true;
        setState(() {

        });
      });
    }

    if (timeOut) {
      return Expanded(
        child: Center(
          child: new Text(
            '''There probably is no open order available yet. You may want to look for other hawker center. 
You may also stay on this page and wait. ''',
            style: new TextStyle(
              fontSize: 18.0,
              color: MyColors.mainRed,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Expanded(child: Center(child: new CircularProgressIndicator()));
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new MyAppBar().build(context),
        backgroundColor: MyColors.mainBackground,
        body: new Container(
            child: new Column(
              children: <Widget>[
                // This is the label right below appbar. The text is "Delivering from [someplace]"
                new Container(
                  margin: new EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child:  StoreConnector<AppState, HawkerCenter>(
                          converter: (store) => store.state.currentHawkerCenter.isPresent ? store.state.currentHawkerCenter.value
                              : null,
                          builder: (_, hawkerCenter) {
                            if (hawkerCenter == null) {
                              return new Text("No hawker center selected",
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return new Text("Delivering from ${hawkerCenter.name}",
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                          },

                        ),
                      )
                    ],
                  ),
                  color: Colors.white,
                ),

                // These are the list of open orders/ order details for this particular hawker center
                StoreConnector<AppState, List<OrderDetail>>(
                  converter: (store) => store.state.openOrderList,
                  builder: (_, openOrderList) {
                    if (openOrderList.length > 0) {
                      return new Expanded(
                        child: new ListView.builder(
                            itemCount: openOrderList.length,
                            itemBuilder: (_, index) {
                              return new OpenOrderListWidget(openOrderList[index]);
                            }
                        )
                        ,
                      );
                    } else {
                      return _displayCircularProgressIndicator();
                    }

                  }

                ),

              ],
            )
        )
    );

  }
}