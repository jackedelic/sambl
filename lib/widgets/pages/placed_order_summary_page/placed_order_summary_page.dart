import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';// Action
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/pages/place_order_page/place_order_page.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/quantity_display.dart';
import 'package:sambl/widgets/pages/view_order_page/view_order_page.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/widgets/shared/my_drawer.dart';
import 'package:sambl/utility/geo_point_utilities.dart';


class PlacedOrderSummaryPage extends StatefulWidget {
  OrderModel orderModel; // when first navigated to this page, we use the orderModel
  // passed from place_order_page. When the real order from the database changes,
  // we replace the orderModel with the real order.

  PlacedOrderSummaryPage() {
    print("inside PlaceOrderSummaryPage constructor ");
  }

  @override
  _PlacedOrderSummaryPageState createState() => _PlacedOrderSummaryPageState();
}

class _PlacedOrderSummaryPageState extends State<PlacedOrderSummaryPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshKey = new GlobalKey<RefreshIndicatorState>();

  Future<Null> _updateETALabel() async {
    refreshKey.currentState.show();
    print("inside updateetalabel");
    //int diff = widget.orderModel.order.orderDetail.eta.difference(DateTime.now()).inMinutes;

    print("updated ETA label");


    return null;
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          leading: new IconButton(
              icon: new Icon(Icons.menu,
                color: MyColors.mainRed,
              ),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              }
            ),
        ).build(context),
        drawer: MyDrawer(),
        backgroundColor: MyColors.mainBackground,
        body: new Column(
            children: <Widget>[
              // This is the title 'Delivering from: ...'
              new Container(
                margin: new EdgeInsets.only(top: 10.0, bottom: 5.0),
                color: Colors.white,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: StoreConnector<AppState, Optional<Order>>(
                        converter: (store) => store.state.currentOrder,
                        builder: (_, currentOrder) {
                          return new Text("${currentOrder.isPresent ? 'Delivering from ${currentOrder.value.orderDetail.hawkerCenter.name}' : 'Loading your order detail'}",
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },

                      ),
                    ),
                  ],
                ),
              ),

              // This is the summary order placed by the current user.
              new Expanded(
                child: StoreConnector<AppState, Optional<Order>>(
                  converter: (store) => store.state.currentOrder,
                  builder: (_, currentOrder) {
                    print("currentOrder is $currentOrder");
                    return new Container(
                      color: Colors.white,
                      margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: new RefreshIndicator(
                        key: refreshKey,
                        onRefresh: _updateETALabel,
                        child: new ListView(
                          children: <Widget>[
                            // 'status' and 'view order button'
                            new Row(
                              children: <Widget>[
                                // 'e.g. Status: pending/awaiting payment '
                                new Expanded(
                                  flex: 5,
                                  child: new Container(
                                    padding: new EdgeInsets.only(left: 20.0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Text("Status:  ",
                                          style: new TextStyle(fontSize: 20.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        new Text("${currentOrder.isPresent
                                            ? (currentOrder.value.isApproved
                                            ? 'Awaiting payment' : (currentOrder.value.isPaid ? 'Paid' : 'Pending'))
                                            : 'loading order'}",
                                          style: new TextStyle(fontSize: 18.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                // 'view order' button
                                new Expanded(
                                  flex: 3,
                                  child: new Container(
                                    margin: new EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, right: 20.0),
                                    padding: new EdgeInsets.all(5.0),
                                    decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(
                                            10.0),
                                        border: new Border.all(
                                            color: MyColors.mainBackground,
                                            width: 2.0)
                                    ),
                                    child: new FlatButton(
                                      onPressed: () {
                                        print(
                                            "View order button tapped! order of orderModel in view_order_page is ${widget
                                                .orderModel}");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return new ViewOrderPage();
                                                }
                                            )
                                        );
                                      },
                                      child: new Center(
                                          child: new Text("View order",
                                            style: const TextStyle(fontSize: 15.0),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            // some space betwn 'status' row and 'eta' row
                            // just a space
                            new Container(
                              height: 10.0,
                              color: new Color(0xFFEBEBEB),
                            ),

                            //ETA and PickUpLocation
                            new Container(
                              padding: new EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  //ETA
                                  new Expanded(
                                    flex: 1,
                                    child: new Row(
                                        children: <Widget>[
                                          new QuantityDisplay(
                                            head: new QuantityDisplayElement(
                                                content: "ETA"),
                                            quantity: new QuantityDisplayElement(
                                                fontSize: 35.0,
                                                content: "${currentOrder.isPresent
                                                    ? currentOrder.value
                                                    .orderDetail.eta
                                                    .difference(DateTime.now())
                                                    .inMinutes
                                                    : 'X'}"),
                                            //"${widget.orderModel.order.orderDetail.eta}"),
                                            tail: new QuantityDisplayElement(
                                                content: "mins"),
                                          )
                                        ]
                                    ),
                                  ),

                                  // pickup location
                                  new Expanded(
                                    flex: 2,
                                    child: new Column(
                                      children: <Widget>[
                                        new Text("Pick-up location",
                                          style: new TextStyle(fontSize: 20.0),
                                        ),

                                        currentOrder.isPresent ?
                                          new FutureBuilder<String>(
                                            future: reverseGeocode(currentOrder.value.orderDetail.pickupPoint),
                                            builder: (_, AsyncSnapshot<String> snapshot){
                                              if (snapshot.hasData) {
                                                return new Text(
                                                  "${snapshot.data}",
                                                  style: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24.0),
                                                  textAlign: TextAlign.center,
                                                );
                                              } else {
                                                return new Text(
                                                    "loading pick up location",
                                                    style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.0),
                                                  textAlign: TextAlign.center,
                                                );
                                              }

                                            }

                                          )
                                        :
                                        new Text(
                                          "loading pick up point",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                          textAlign: TextAlign.center,
                                        ),


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Open Chat
              new Center(
                child: new Container(
                  margin: new EdgeInsets.only(top: 30.0),
                  color: Colors.white,
                  // TRIGGER OpenChat Action
                  child: new StoreConnector<AppState, Store<AppState>>(
                    converter: (store) => store,
                    builder: (_, store) {
                      return new FlatButton(
                        padding: new EdgeInsets.all(10.0),
                        onPressed: () {
                          //TRIGGER SubmitOrderAction.
                          Optional<Order> newOrder = store.state.currentOrder;
                          // The reducer shd create a new state w new Order. Then inform Firebase (async).
                          //store.dispatch(new OrderAction(order: newOrder));
                          print("Opening Chat.");

                          // Navigate to a page to chat page
                          /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return new ScopedModelDescendant<OrderModel>(
                                                  builder: (context, child, orderModel) {
                                                    return new PlacedOrderSummaryPage(orderModel);
                                                  },

                                                );
                                              }
                                          )
                                      );*/


                        },
                        child: new Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: new Text("Open Chat",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.green,
                                fontSize: 17.0
                            ),
                          ),
                        ),
                      );
                    },

                  ),


                ),
              ),

              // some space betwn 'Open Chat' row and 'Authorise Payment' row
              // just a space
              new Container(
                height: 10.0,
                color: new Color(0xFFEBEBEB),
              ),

              // Authorise Payment
              new Center(
                child: StoreConnector<AppState, Store<AppState>>(
                  converter: (store) => store,
                  builder: (_, store) {
                    return new Container(
                      color: store.state.currentOrder.isPresent ? (store.state.currentOrder.value.isApproved ? Colors.white : Colors.grey) : Colors.grey,
                      // TRIGGER AuthorisePayment Action
                      child: new FlatButton(
                        padding: new EdgeInsets.all(10.0),
                        onPressed: () {
                          print(store.state.currentOrder.value.isApproved);
                          if (store.state.currentOrder.isPresent && store.state.currentOrder.value.isApproved) {

                            //TRIGGER SubmitOrderAction.
                            //Optional<Order> newOrder = store.state.currentOrder;
                            // The reducer shd create a new state w new Order. Then inform Firebase (async).
                            //store.dispatch(new OrderAction(order: newOrder));

                            //store.dispatch(action);
                            print("Authorise Payment.");

                            // Navigate to a page to chat page
                            /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                              return new ScopedModelDescendant<OrderModel>(
                                                builder: (context, child, orderModel) {
                                                  return new PlacedOrderSummaryPage(orderModel);
                                                },

                                              );
                                            }
                                        )
                                    );*/
                          }
                        },
                        child: new Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: new Text("Authorise Payment",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: store.state.currentOrder.isPresent ? (store.state.currentOrder.value.isApproved ? MyColors.mainRed : Colors.white) : Colors.white,
                                fontSize: 17.0
                            ),
                          ),
                        ),
                      ),





                    );
                  },
                ),
              ),

            ]
        ),
      );
    }


}



