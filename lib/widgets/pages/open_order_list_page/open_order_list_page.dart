import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/async_action/get_delivery_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sambl/main.dart'; // to use the store created in main.dart.
import 'package:sambl/state/app_state.dart';

/*
This is the page directed when the user wants to see any available food delivery services
(when he pressed 'order' button in the home page).
*/

class OpenOrderListPage extends StatefulWidget {
  @override
  _OpenOrderListPageState createState() => new _OpenOrderListPageState();
}

class _OpenOrderListPageState extends State<OpenOrderListPage> {
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
                   child:  new Text("Delivering from",
                     style: new TextStyle(
                       fontSize: 20.0,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 )
                ],
              ),
              color: Colors.white,
            ),

            // These are dummies expansion tiles
            new Expanded(
                child: new ListView(
                  children: <Widget>[
                    new OpenOrderListWidget(
                      new OrderDetail(
                        hawkerCenter: new HawkerCenter(
                            new GeoPoint(1.314891217509645, 103.7642318178891),
                            "Clementi Mall food Court",
                            <HawkerCenterStall>[new HawkerCenterStall(name: "Mixed Rice")],
                            "64ceajXT6dpCHIf6J9pQ"
                          ),
                        pickupPoint: new GeoPoint(1.22, 12.3),
                        closingTime: DateTime.now(),
                        eta: DateTime.now().add(new Duration(minutes: 45)),
                        delivererUid: "2uaFyuY2P8TMgBfBO2IspiqmUV82",
                        maxNumberofDishes: 4,
                      ),
                    ),
                  ],
                ),
            ),

            // We trigger 'getDeliveryListAction', and then build a list of 'open orders' based on what the
            // openOrderList in our new appState.
//

            //Below will be the real list of items, more specifically a stream of items (since we're
              // using StreamBuilder).
//            new Expanded(
//              child: new StreamBuilder(
//                stream: Firestore.instance.collection('users').snapshots(),
//                builder: (context, snapshot){
//
//                  if (snapshot.hasData) {
//                    return new ListView.builder(
//
//                      itemCount: snapshot.data.documents.length,
//                      itemBuilder: (context, index){
//
//                        JioEntry entry = new JioEntry(
//                            hawkerName: snapshot.data.documents[index]['hawker_name'],
//                            pickupPoint: snapshot.data.documents[index]['pickup_pt'],
//                            closingTime: snapshot.data.documents[index]['closing_time'],
//                            eta: snapshot.data.documents[index]['eta'],
//                            jioCreator: snapshot.data.documents[index]['user_name']
//                        );
//                        // Create our JioEntryWidget object using the snapshot data we received.
//                        var entryWidget = new JioEntryWidget(entry);
//                        return entryWidget;
//                      },
//                    );
//                  } else {
//                    print(snapshot.connectionState);
//                  }
//                  return new CircularProgressIndicator();
//                },
//              ),
//            ),



          ],
        )
      )
    );

  }
}
