import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart'; // Action
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).

import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/pages/placed_order_summary_page/placed_order_summary_page.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/async_action/firestore_write_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sambl/action/write_action.dart';
class PlaceOrderPage extends StatefulWidget {
  final OrderModel orderModel;

  PlaceOrderPage(this.orderModel);

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {

  GlobalKey<FormState> _addStallFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  /// This dialog shows up when +Add stall button is tapped. It returns Future<Stall> future when
  /// popped from Navigator.
  Future<Stall> _addStallDialog() {
    TextEditingController textEditingController = new TextEditingController();
    return showDialog<Stall>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Stall Name"),
            content: new Form(
              key: _addStallFormKey,
              child: new TextFormField(
                controller: textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    errorMaxLines: 2,
                    labelText: 'stall name',
                    hintText: 'eg. Wakanda stall'
                ),
                validator: _validateAddStallForm,
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Cancel")),
              new FlatButton(
                  onPressed: () {
                    if (_addStallFormKey.currentState.validate()) {
                      Stall stall = new Stall(identifier: new HawkerCenterStall(name: textEditingController.text), dishes: new List<Dish>());
                      Navigator.of(context).pop(stall);
                    }

                  },
                  child: new Text("Add")),
            ],
          );
        }
    );
  }

  /// This validates the user input when adding stall
  String _validateAddStallForm(String input) {
    if (input.isEmpty) {
      return "Please enter the name of the stall you want to add.";
    }
    return null;
  }
  /// This validates the entire order (all the stalls and their assoiated dishes)
  Future<bool> _validateOrder(OrderModel orderModel) async {
    if (orderModel.order.stalls.isEmpty) {
      await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text("No stall added."),
              content: new Text("Add the stall from which you want to order. Click the +Add button below."),
            );
          }
      );
      return false;
    } else if (orderModel.order.stalls.any((stall)=>stall.dishes.isEmpty)) {
      await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text("Stall added but no dish added."),
              content: new Text("Add the dish you want to order. Click the +Add dish button from within the stall card."),
            );
          }
      );
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    // Inside this widget tree, we have three buttons that trigger some Action -
    // add dish, add stall, and place order.
    return new ScopedModel(
      model: widget.orderModel,
      child: Scaffold(
        appBar: new MyAppBar().build(context),
        backgroundColor: new Color(0xFFEBEBEB),
        body: new Column(
          children: <Widget>[
            // "Delivering From" title/banner.
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
                      }
                    ),
                  )
                ],
              ),
              color: Colors.white,
            ),

            // AddStallCard cards
            // Use Scoped Model Descendant to update the current Order model.
            new ScopedModelDescendant<OrderModel>(
              builder: (context, child, orderModel) {
                print("inside addstallcard, ordermodel is :  $orderModel");
                return new Expanded(
                    child: new ListView.builder(
                        itemCount: orderModel.order.stalls?.length ?? 0,
                        itemBuilder: (BuildContext context, int n) {
                          return new AddStallCard( orderModel.order.stalls[n]);

                        }
                    )
                );
              },

            ),

            // just a space
            new Container(
              height: 10.0,
              color: new Color(0xFFEBEBEB),
            ),

            // Add stall button. Right at the bottom.
            new Container(
              color: Colors.white,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.all(20.0)), // Just some space to the left.
                  // this add stall button edit orderModel.
                  new ScopedModelDescendant<OrderModel>(

                    builder: (context, child, orderModel){
                      return new FlatButton(
                        padding: new EdgeInsets.all(10.0),
                        onPressed: () async {
                          // pop up a textfield to for user to input stall name.
                          // We then create a Stall object based on the input.
                          Stall stall = await _addStallDialog();
                          if (stall == null) return;
                          // Update orderModel, then notify all descendants.
                          // Bad practice since I accessed order field directly.
                          orderModel.order.stalls.add(stall);
                          orderModel.editOrderModel(order: orderModel.order);

                          // TRIGGER AddStallAction action, which takes in our newly created stall.
                          // The reducer will add this newly created stall and add it to our existing list
                          // of stalls. The reducer shd create a new state w new Order obj w new list of stalls.
                          // store.dispatch(new AddStallAction(stall: stall));
                          print("stall added: " + stall.identifier.name);
                        },
                        child: new Text("+ Add stall",
                          style: new TextStyle(
                              fontSize: 17.0
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // just a space
            new Container(
              height: 10.0,
              color: new Color(0xFFEBEBEB),
            ),

            //Place order button
            new Center(
              child: new Container(
                color: Colors.white,
                // TRIGGER SubmitOrderAction which I believe is async and involves Middleware(thunk).
                child: new StoreConnector<AppState, Store<AppState>>(
                  converter: (store) => store,
                  builder: (_, store){
                    return new ScopedModelDescendant<OrderModel>(
                      builder: (context, child, orderModel) {
                        return new FlatButton(
                          padding: new EdgeInsets.all(10.0),
                          onPressed: () async {
                            // Check if all inputs (added stalls and associated dishes) are correct before placing the order.
                            bool orderIsValid = await _validateOrder(orderModel);
                            if (!orderIsValid) return;
                            //TRIGGER SubmitOrderAction.
                            Optional<Order> newOrder = store.state.currentOrder;
                            // The reducer shd create a new state w new Order. Then inform Firebase (async).

                            store.dispatch(PlaceOrderAction(orderModel.order));
                            print("Order placed. appstate's currentorder is ${store.state.currentOrder}");


                            // Navigate to a page to view ur order

                            print("orderModel in placeorderpage is ${widget.orderModel}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return new PlacedOrderSummaryPage(widget.orderModel);
                                    }
                                )
                            );




                          },
                          child: new Container(
                            width: MediaQuery.of(context).size.width,
                            child: new Text("Place Order",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Colors.green,
                                  fontSize: 17.0
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },

                ),


              ),
            ),

          ],
        ),
      ),
    );
  }
}

// This class constructs a card that represents a stall. When a user click 'Add Stalls' button,
// a new AddStallCard object will be created. It contains info such as the dish the user wants to
// order.
class AddStallCard extends StatefulWidget {
  Stall stall;


  AddStallCard(this.stall);

  @override
  _AddStallCardState createState() => _AddStallCardState();
}

class _AddStallCardState extends State<AddStallCard> {

  final GlobalKey<FormState> _addDishFormKey = new GlobalKey<FormState>();

  /// sanitise the user input for adding dish.
  String _validateAddDishForm(String input) {
    if (input.isEmpty) {
      return "Please enter the dish you want to add.";
    }

    return null;
  }

  /// This dialog shows up when +Add dish button is tapped. It returns Future<Dish> future when
  /// popped from Navigator.
  Future<Dish> _addDishDialog() {
    TextEditingController textEditingController = new TextEditingController(); // input text controller for the dialog
    return showDialog<Dish>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Add dish"),
            content: new Form(
              key: _addDishFormKey,
              child: new TextFormField(
                controller: textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    errorMaxLines: 2,
                    labelText: "What's the dish you want to order?",
                    hintText: 'eg. butter chicken rice. Extra rice. '
                ),
                validator: _validateAddDishForm,
              ),

            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Cancel")),
              new FlatButton(
                  onPressed: () {
                    // check if input is valid
                    if (_addDishFormKey.currentState.validate()) {
                      Dish dish = new Dish(name: textEditingController.text);
                      Navigator.of(context).pop(dish); // When popped, the dish is wrapped in a Future
                      // object which is returned by this _addDishDialog().
                    }

                  },
                  child: new Text("Add")),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<OrderModel>(
      builder: (context, child, orderModel) {
        return new Container(
          // bottom padding for the card
          padding: new EdgeInsets.only(bottom: 15.0),
          child: new Column(
            children: <Widget>[

              // The title of the card, which is the stall name
              new Container(
                color: new Color(0xFF9A9A9A),
                padding: new EdgeInsets.all(15.0),
                child: new GestureDetector(
                  onTap: () {
                    print("fuck");
                  },
                  onDoubleTap: () {
                    print("double tapped title");
                  },
                  onLongPress: () {
                    orderModel.order.stalls.removeWhere((stall) => stall.identifier == widget.stall.identifier);
                    orderModel.notifyListeners();
                    for (int i = 0; i < orderModel.order.stalls.length; i++) {
                      print("remaining dish: " + orderModel.order.stalls[i].toString());
                    }
                  },
                  child: new Row(
                    children: <Widget>[
                      new Text(widget.stall.identifier.name,
                        // The grey part of the card
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 17.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // The white part of the card.
              new Container(
                color: Colors.white,
                padding: new EdgeInsets.all(10.0),
                // dishes for this particular stall. Remember each card represents one stall.
                child: new Column(
                  children: <Widget>[
                    // The ListView wraps all dishes in this card. Remember each card represents one stall.
                    new Container(
                      height: 150.0,
                      child: new ScopedModelDescendant<OrderModel>(

                        builder: (context, child, orderModel) {
                          print("inside list of dishes, dishes.length is ${widget.stall.dishes.isEmpty ? 0 :  widget.stall.dishes.length}");
                          return new ListView.builder(
                              itemCount: widget.stall.dishes?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                // A column consists of the string for stall name and a divider.
                                return new Column(
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        new Expanded(
                                          child: new Container(
                                            padding: new EdgeInsets.all(10.0) ,
                                            child: new Text(widget.stall.dishes[index].name,
                                              style: new TextStyle(fontSize: 20.0,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Divider(
                                      color: Colors.black,
                                      height: 3.0,
                                    )
                                  ],
                                );

                              }
                          );
                        },
                      ),
                    ),

                    // This is the +Add dish button
                    new Row(
                      children: <Widget>[
                        new Padding(padding: new EdgeInsets.all(16.0)), // Just some space to the left.
                        new ScopedModelDescendant<OrderModel>(
                          builder: (context, child, orderModel){
                            return new FlatButton(
                              padding: new EdgeInsets.all(10.0),
                              onPressed: () async {
                                // AddDishAction is dispatched. Create a new dish and add it to this
                                // particular stall. This addStallCard widget is rebuilt with the
                                // newly added dish.
                                Dish dish = await _addDishDialog();

                                if (dish == null) return;

                                // update our orderModel
                                widget.stall.dishes.add(dish);
                                print("indise add dish button, this particular stall's dish lengh is ${widget.stall.dishes.length}");
                                orderModel.editOrderModel(order: orderModel.order); // notify
                                print("indise add dish button, this particular stall's dish lengh is ${orderModel.order.stalls[0].dishes.length}");
                                // The reducer shd create new state w a new Order obj w new stall w one more dish.
                                //store.dispatch(new AddDishAction(stall: widget.stall, dish: dish));

                                print("dish added: " + dish.name);
                              },
                              child: new Text("+ Add dish"),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}