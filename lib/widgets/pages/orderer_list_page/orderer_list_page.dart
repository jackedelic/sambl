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
                return new CustomScrollView(
                  slivers: new List  .from(store.state.currentDeliveryList.pending.orders.isNotEmpty ? new PendingDeliveryListLayout(store).build(context) : [])
                                    ..addAll(store.state.currentDeliveryList.approved.orders.isNotEmpty ? new ApprovedDeliveryListLayout(store).build(context) : [])
                                    ..addAll(store.state.currentDeliveryList.paid.orders.isNotEmpty ? new PaidDeliveryListLayout(store).build(context) : []),

                );
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

                      bool safeToClose = store.state.currentDeliveryList.pending.orders.isNotEmpty && store.state.currentDeliveryList.approved.orders.isNotEmpty;

                      return new Container(
                        child: Material(
                          color: safeToClose ? Colors.white : Colors.grey,
                              child: InkWell(
                                onTap: (){
                                  // dispatch close order action
                                  // make sure all orders are paid before closing order
                                  if (safeToClose) {
                                    store.dispatch(new CloseOpenOrderAction());
                                    print("Inside orderer list page: CloseOpenOrderAction dispatched.");
                                  } else {
                                    print("Orders not closed. Please make sure all orders are paid!");
                                  }

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: new Text("Close Order",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20.0, color: safeToClose ? Colors.green : Colors.white),
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