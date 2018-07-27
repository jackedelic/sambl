import 'package:quiver/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/main.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/main.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_drawer.dart';
import 'package:sambl/model/order.dart';

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
                StoreConnector<AppState, DeliveryList>(
                  converter: (store) => store.state.currentDeliveryList.pending,
                  builder: (_, pendingDeliveryList) {

                    // calculate the total height needed for this pending delivery list.
                    double totalPendingDeliveryListHeight = 0.0;
                    pendingDeliveryList.orders.forEach((_, order) {
                      order.stalls.forEach((stall){
                        stall.dishes.forEach((dish){
                          totalPendingDeliveryListHeight += dishRowHeight;
                        });

                      });
                      totalPendingDeliveryListHeight += (deliveryChargeHeight + approvalButtonHeight * 2 + 60);
                    });

                    // The whole pending delivery list.
                    return new Container(
                        height: totalPendingDeliveryListHeight,
                        child: new ListView.builder(
                            itemCount: pendingDeliveryList.orders.length,
                            // for each order
                            itemBuilder: (_, int n) {
                              print("length is ${pendingDeliveryList.orders.length}");
                              print(pendingDeliveryList.orders.values);

                              // calculate the total height needed for ths order.
                              double totalOrderHeight = 0.0;
                              pendingDeliveryList.orders.values.toList()[n].stalls.forEach((stall) {
                                stall.dishes.forEach((dish) {
                                  totalOrderHeight += dishRowHeight;
                                });
                              });

                              // A particular order in this pending delivery list.

                              // Create an exact copy of this order. We'll later set price for the dishes in this order
                              Order orderWithPrice = pendingDeliveryList.orders.values.toList()[n];
                              return Container(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 5.0),
                                child: new ExpansionTile(
                                  backgroundColor: Colors.white,
                                  title: new Text("${pendingDeliveryList.orders.values.toList()[n].ordererName}",
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  trailing: new Text("pending",
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  children: <Widget>[
                                    //recompile the order with the new prices, then approve/reject the recompiled order

                                    Container(
                                      height: totalOrderHeight + deliveryChargeHeight + approvalButtonHeight,
                                      child: Column(
                                        children: <Widget>[
                                          // one order
                                          Expanded(
                                            child: new ListView.builder(
                                                itemCount: pendingDeliveryList.orders.values.toList()[n].stalls.length,
                                                itemBuilder: (_, int stallIndex) {
                                                  // for each stall, this is the list of dishes

                                                  print("stalls");
                                                  return Container(
                                                    height: pendingDeliveryList.orders.values.toList()[n].stalls[stallIndex].dishes.length * dishRowHeight ,
                                                    child: new ListView.builder(
                                                        itemCount: pendingDeliveryList.orders.values.toList()[n].stalls[stallIndex].dishes.length,
                                                        itemBuilder: (_, int dishIndex) {

                                                          // we're now inside the dish row.
                                                          // Here we create textController for the price of this dish.
                                                          // Then we set the price of the dish based on this text controller's value
                                                          TextEditingController priceTextController = new TextEditingController();
                                                          priceTextController.text = orderWithPrice.stalls[stallIndex].dishes[dishIndex].isPriceSpecified ?
                                                                                  "${orderWithPrice.stalls[stallIndex].dishes[dishIndex].price}" :
                                                                                    null;
                                                          priceTextController.addListener((){
                                                            if (double.tryParse(priceTextController.text) != null) {
                                                              print("price is ${priceTextController.text}");
                                                              orderWithPrice.stalls[stallIndex].dishes[dishIndex] = Dish
                                                                  .withPrice(orderWithPrice.stalls[stallIndex].dishes[dishIndex].name, double.parse(priceTextController.text));
                                                              print("now the current dish (${orderWithPrice.stalls[stallIndex].dishes[dishIndex].name}) has price : ${orderWithPrice.stalls[stallIndex].dishes[dishIndex].price}");
                                                            }

                                                          });
                                                          return new Container(
                                                            // This row is 'stallname dishname      setpricebutton'
                                                            child: new Row(

                                                              children: <Widget>[
                                                                // some space to the left
                                                                new Padding(padding: const EdgeInsets.all(18.0),),
                                                                // stall name + dishname
                                                                new Expanded(
                                                                  flex: 3,
                                                                  child: new Text("[${pendingDeliveryList.orders.values.toList()[n].stalls[stallIndex].identifier.name}]"
                                                                      "${pendingDeliveryList.orders.values.toList()[n].stalls[stallIndex].dishes[dishIndex].name}"),
                                                                ),

                                                                // setPrice button
                                                                new Expanded(
                                                                  flex: 1,
                                                                  child: Container(
                                                                    margin: const EdgeInsets.all(3.0),
                                                                    padding: const EdgeInsets.all(1.0),
                                                                    decoration: new BoxDecoration(
                                                                        border: Border.all(color: Colors.grey, width: 2.0),
                                                                        borderRadius: BorderRadius.circular(10.0)
                                                                    ),
                                                                    child: InkWell(
                                                                        child: Center(
                                                                          child: new TextFormField(
                                                                            controller: priceTextController,
                                                                            keyboardType: TextInputType.numberWithOptions(),
                                                                            textAlign: TextAlign.center,
                                                                            decoration: InputDecoration(
                                                                                hintText: "Set Price",border: InputBorder.none,
                                                                                contentPadding: EdgeInsets.symmetric(vertical: 2.0)
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),

                                                                // some space to the right
                                                                new Padding(padding: const EdgeInsets.all(10.0),),

                                                              ],

                                                            ),
                                                          );
                                                        }
                                                    ),
                                                  );
                                                }
                                            ),
                                          ),

                                          // This is the 'delivery charge' row
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            child: new Row(
                                              children: <Widget>[
                                                new Padding(padding: const EdgeInsets.all(10.0),),
                                                new Expanded(
                                                    flex: 3,
                                                    child: new Text("Delivery charge: S\$${pendingDeliveryList.orders.values.toList()[n].getDeliveryfee()}")
                                                ),
                                                new Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(1.0),
                                                    decoration: new BoxDecoration(
                                                        border: Border.all(color: Colors.grey, width: 2.0),
                                                        borderRadius: BorderRadius.circular(10.0)
                                                    ),
                                                    child: InkWell(
                                                        child: Center(
                                                          child: new Text("Chat",
                                                            style: new TextStyle(
                                                              fontSize: 18.0,
                                                                color: Colors.black38,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ),
                                                new Padding(padding: const EdgeInsets.all(10.0),),
                                              ],
                                            ),
                                          ),

                                          // This is the hori divider separating 'delivery charge' row and 'approve/reject' row
                                          Container(height: 8.0, width: MediaQuery.of(context).size.width, color: MyColors.mainBackground,),

                                          // This is the approve button

                                          new Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: new Row(
                                              children: <Widget>[
                                                // approve button.
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: (){

                                                      bool valid = true;
                                                      // 1. Make sure that all dishes have prices set
                                                      for (int i = 0; i < orderWithPrice.stalls.length; i++) {
                                                        for (int j = 0; j < orderWithPrice.stalls.length; i++) {
                                                          if (orderWithPrice.stalls[i].dishes[j].isPriceSpecified == false) {
                                                            valid = false;
                                                            break;
                                                          }
                                                        }
                                                      }
                                                      // dispatch recompiled order - orderWithPrice
                                                      if (valid) {

                                                      } else {
                                                        print("Please set all prices of all dishes!");
                                                      }

                                                    },
                                                    child: new Text("Approve",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.lightGreen,
                                                          fontSize: 25.0
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // This is the hori divider separating 'reject' row from 'approve' row
                                          Container(height: 8.0, width: MediaQuery.of(context).size.width, color: MyColors.mainBackground,),

                                          // This s the reject button
                                          new Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: new Row(
                                              children: <Widget>[
                                                // reject button.
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: (){},
                                                    child: new Text("Reject",
                                                      textAlign: TextAlign.center,
                                                      style: new TextStyle(
                                                          color: MyColors.mainRed,
                                                          fontSize: 25.0
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              );
                            }
                        )

                    );
                  },
                ),



                // approved delivery list
                StoreConnector<AppState, DeliveryList>(
                  converter: (store) => store.state.currentDeliveryList.approved,
                  builder: (_, approvedDeliveryList) {
                    return new Container(
                      height: 10.0,
                        child: new ListView.builder(
                            itemCount: approvedDeliveryList.orders.length,
                            itemBuilder: (_, int n) {
                              return new ExpansionTile(
                                title: new Text("${approvedDeliveryList.orders[n].ordererName}"),
                                trailing: new Text("approved"),
                                children: <Widget>[
                                  new Text("hi there i am jack")
                                ],
                              );
                            }
                        )

                    );
                  },
                ),

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