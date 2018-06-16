import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sambl/model/order_detail.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';

/*
This is the page directed when the user wants to see any available food delivery services.
*/

class OpenOrderListPage extends StatefulWidget {
  @override
  _OpenOrderListPageState createState() => new _OpenOrderListPageState();
}

class _OpenOrderListPageState extends State<OpenOrderListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Container(
            padding: new EdgeInsets.only(left: 75.0),
            child: new Text('HawkerJio',
              style: new TextStyle(
                color: new Color(0xFFDF1B01),
                fontFamily: 'Indie Flower',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),
        backgroundColor: Colors.white,
        leading: new Icon(Icons.menu, color: new Color(0xFFDF1B01),),
        elevation: 0.0,
      ),
      backgroundColor: new Color(0xFFEBEBEB),
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
                    new JioEntryWidget(new OrderDetail()),
                    new JioEntryWidget(new OrderDetail()),
                    new JioEntryWidget(new OrderDetail())
                  ],
                ),
            ),

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
