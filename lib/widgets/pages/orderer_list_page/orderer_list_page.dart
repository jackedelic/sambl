import 'dart:async';

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
import 'package:sambl/widgets/pages/orderer_list_page/paid_delivery_list_layout.dart';

class OrdererListPage extends StatefulWidget {
  @override
  _OrdererListPageState createState() => _OrdererListPageState();
}

class _OrdererListPageState extends State<OrdererListPage> {
  double dishRowHeight = 35.0;
  double deliveryChargeHeight = 60.0;
  double approvalButtonHeight = 108.0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool timeOut = false;

  Widget _displayCircularProgressIndicator() {
    print("circular progressing in available_hawker_center_page");
    if (!timeOut) {
      Future.delayed(const Duration(seconds: 4), () {
        timeOut = true;
        setState(() {

        });
      });
    }
    if (timeOut) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Center(
            child: new Text(
              '''No orders yet. We'll display them once we've found any. ''',
              style: new TextStyle(
                fontSize: 18.0,
                color: MyColors.mainRed,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Expanded(child: Center(child: new CircularProgressIndicator()));
  }

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
            //height: 400.0,
            child: StoreConnector<AppState, Store<AppState>>(
              converter: (store) => store,
              builder: (_, store){
                if (store.state.currentDeliveryList.pending.orders.isNotEmpty ||
                    store.state.currentDeliveryList.approved.orders.isNotEmpty ||
                    store.state.currentDeliveryList.paid.orders.isNotEmpty) {

                  return new CustomScrollView(
                    slivers: new List  .from(store.state.currentDeliveryList.pending.orders.isNotEmpty ? new PendingDeliveryListLayout(store).build(context) : [])
                      ..addAll(store.state.currentDeliveryList.approved.orders.isNotEmpty ? new ApprovedDeliveryListLayout(store).build(context) : [])
                      ..addAll(store.state.currentDeliveryList.paid.orders.isNotEmpty ? new PaidDeliveryListLayout(store).build(context) : []),

                  );

                } else {
                  return new Column(
                    children: <Widget>[_displayCircularProgressIndicator()],
                  );
                }

              },
            ),
          ),

          // This is the close delivery button
          new Container(
            height: 60.0,
            child: new Column(
              children: <Widget>[
                // grey padding above the close delivery button
                new Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),),

                // the button itself
                Expanded(
                  child: StoreConnector<AppState, Store<AppState>>(
                    rebuildOnChange: false,
                    converter: (store) => store,
                    builder: (_, store){
                      return new Container(
                        child: Material(
                          color: Colors.white,
                              child: InkWell(
                                onTap: (){
                                  store.dispatch(new CloseOpenOrderAction());
                                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: new Text("Close Open Order",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20.0, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                    },
                  ),
                ),

              ],
            ),
          )



        ],
      ),
    );
  }
}