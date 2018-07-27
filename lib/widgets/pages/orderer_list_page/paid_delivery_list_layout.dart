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

class PaidDeliveryListLayout extends StatefulWidget {
  @override
  _PaidDeliveryListLayoutState createState() => _PaidDeliveryListLayoutState();
}

class _PaidDeliveryListLayoutState extends State<PaidDeliveryListLayout> {
  double totalPaidDeliveryListHeight = 0.0;
  double dishRowHeight = 35.0;
  double deliveryChargeHeight = 60.0;
  double reportDeliveryButtonHeight = 90.0;

  @override
  void initState() {
    super.initState();
    print("inside initState of PaidDeliveryListLayout State");

  }

  @override
  Widget build(BuildContext context) {
    print("inside build of PaidDeliveryListLayoutState");


    // The whole pending delivery list.
    return StoreConnector<AppState, DeliveryList>(
      converter: (store) => store.state.currentDeliveryList.paid,
      builder: (_, paidDeliveryList) {
        // calculate the total height needed for this approved delivery list.

        print("totalPaidDeliveryListHeight is $totalPaidDeliveryListHeight");
        paidDeliveryList.orders.forEach((_, order) {
          print("paid order is  $order");
          order.stalls.forEach((stall){
            stall.dishes.forEach((dish){
              totalPaidDeliveryListHeight += dishRowHeight;
            });

          });
          totalPaidDeliveryListHeight += (deliveryChargeHeight + reportDeliveryButtonHeight + 60);
          print("totalPaidDeliveryHeight is currently $totalPaidDeliveryListHeight");
        });

        return new Container(
            height: totalPaidDeliveryListHeight,
            child: new ListView.builder(
                itemCount: paidDeliveryList.orders.length,
                // for each order
                itemBuilder: (_, int n) {
                  print("length is ${paidDeliveryList.orders.length}");
                  print(paidDeliveryList.orders.values);

                  // calculate the total height needed for ths order.
                  double totalOrderHeight = 0.0;
                  paidDeliveryList.orders.values.toList()[n].stalls.forEach((stall) {
                    stall.dishes.forEach((dish) {
                      totalOrderHeight += dishRowHeight;
                    });
                  });

                  print("paid orders at n = $n:${paidDeliveryList.orders.values.toList()[n].ordererName}");
                  // A particular order in this approved delivery list.

                  // Create an exact copy of this order. We'll later set price for the dishes in this order
                  Order orderWithPrice = paidDeliveryList.orders.values.toList()[n];
                  return Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: new ExpansionTile(
                      backgroundColor: Colors.white,
                      title: new Text("${paidDeliveryList.orders.values.toList()[n].ordererName}",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      trailing: new Text("Paid",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      children: <Widget>[

                        // The entire pending delivery list
                        Container(
                          height: totalOrderHeight + deliveryChargeHeight,
                          child: Column(
                            children: <Widget>[
                              // one order
                              Expanded(
                                child: new ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: paidDeliveryList.orders.values.toList()[n].stalls.length,
                                    itemBuilder: (_, int stallIndex) {

                                      // for each stall, this is the list of dishes
                                      print("stalls");
                                      return Container(
                                        height: paidDeliveryList.orders.values.toList()[n].stalls[stallIndex].dishes.length * dishRowHeight ,
                                        child: new ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: paidDeliveryList.orders.values.toList()[n].stalls[stallIndex].dishes.length,
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
                                                      child: new Text("[${paidDeliveryList.orders.values.toList()[n].stalls[stallIndex].identifier.name}]"
                                                          "${paidDeliveryList.orders.values.toList()[n].stalls[stallIndex].dishes[dishIndex].name}"),
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
                                                              child: new Text("${paidDeliveryList.orders.values.toList()[n]
                                                                    .stalls[stallIndex].dishes[dishIndex].price.toString()}",

                                                                textAlign: TextAlign.center,
                                                                style: new TextStyle(

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
                                        child: new Text("Delivery charge: S\$${paidDeliveryList.orders.values.toList()[n].getDeliveryfee()}")
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

                              // This is the Report Delivery Row
                              new Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: new Row(
                                  children: <Widget>[
                                    // Report Delivery button.
                                    Expanded(
                                      child: StoreConnector<AppState, Store<AppState>>(
                                        converter: (store) => store,
                                        builder: (_, store) {
                                          return  InkWell(
                                            onTap: (){

                                              // Report this order
                                              store.dispatch(new ReportDeliveryAction(paidDeliveryList.orders.keys.toList()[n]));

                                            },
                                            child: new Text("Report Order",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 25.0
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

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
    );
  }
}
