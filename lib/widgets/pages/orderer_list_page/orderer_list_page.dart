import 'package:quiver/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/main.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_drawer.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/async_action/firestore_write_action.dart';
import 'package:sambl/widgets/pages/orderer_list_page/pending_delivery_list_layout.dart';
import 'package:sambl/widgets/pages/orderer_list_page/approved_delivery_list_layout.dart';

class OrdererListPage extends StatefulWidget {
  @override
  _OrdererListPageState createState() => _OrdererListPageState();
}

class _OrdererListPageState extends State<OrdererListPage> {
  double dishRowHeight = 35.0;
  double deliveryChargeHeight = 60.0;
  double approvalButtonHeight = 108.0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: new MyAppBar(
        leading: new IconButton(
          icon: const Icon(Icons.menu),
          color: MyColors.mainRedSwatches,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),

      ).build(context),

      backgroundColor: MyColors.mainBackground,
      body: new Column(
        children: <Widget>[
          // This is the label right below appbar. The text is "Delivering from [someplace]"
          new Container(
            margin: new EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child:  StoreConnector<AppState, Optional<HawkerCenter>>(
                    converter: (store) => store.state.currentHawkerCenter,
                    builder: (_, currentHawkerCenter){
                      return new Text("${currentHawkerCenter.isPresent ? 'Delivering from ${currentHawkerCenter.value.name}' : 'loading hawker center...'}",
                        style: new TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            color: Colors.white,
          ),


          // This is the list of users who subscribe to the deliverer's delivery.
          Expanded(
            child: new ListView(
              children: <Widget>[

                // pending delivery list
                new PendingDeliveryListLayout(),


                // approved delivery list
                new ApprovedDeliveryListLayout(),


                // paid delivery list
                StoreConnector<AppState, DeliveryList>(
                  converter: (store) => store.state.currentDeliveryList.paid,
                  builder: (_, paidDeliveryList) {
                    return new Container(
                      height: 10.0,
                        child: new ListView.builder(
                            itemCount: paidDeliveryList.orders.length,
                            itemBuilder: (_, int n) {
                              return new ExpansionTile(
                                title: new Text("${paidDeliveryList.orders[n].ordererName}"),
                                trailing: new Text("Paid"),
                                children: <Widget>[
                                  new Text("")
                                ],
                              );
                            }
                        )

                    );
                  },
                ),

              ],
            ),
          ),



        ],
      ),
    );
  }
}