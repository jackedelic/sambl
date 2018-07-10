import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart'; // Action
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).
import 'package:sambl/action/write_action.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/async_action/firestore_write_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PlaceOrderPage extends StatefulWidget {
  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  // our list of stalls
  List<Stall> stalls;


  @override
  void initState() {
    super.initState();
    stalls = new List<Stall>();
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
          content: new TextField(
            controller: textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: 'stall name',
              hintText: 'eg. Wakanda stall'
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
                Stall stall = new Stall(identifier: new HawkerCenterStall(name: textEditingController.text), dishes: new List<Dish>());

                Navigator.of(context).pop(stall);
              },
              child: new Text("Add")),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inside this widget tree, we have three buttons that trigger some Action -
    // add dish, add stall, and place order.
    return Scaffold(
      appBar: new AppBar(
        title: new Container(
          padding: new EdgeInsets.only(left: 75.0),
          child: new Text('Sambl',
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

          // AddStallCard cards
          // NEED A STORE CONNECTOR TO DETECT CHANGES WHEN NEW STALL IS ADDED
          new StoreConnector<AppState, Store<AppState>>(
            converter: (store) => store,
            builder: (_, store){
              return new Expanded(
                  child: new ListView.builder(
                      itemCount: stalls.isEmpty ? 0 : stalls.length,
                      itemBuilder: (BuildContext context, int n) {
                        return new AddStallCard(
                            new Stall(
                                identifier: new HawkerCenterStall(name: "${stalls[n].identifier.name}"),
                                dishes: stalls[n].dishes,
                                //<Dish>[
//                                    new Dish(name: "High Calorie yummy food"),
//                                    new Dish(name: "Low Calorie not so yummy food"),
//                                    new Dish(name: "African meat"),
//                                    new Dish(name: "Sexy fish"),
//                                    new Dish(name: "Sizzling butter pork with extra oozing cheese that is "
//                                        "almost melting but not really. "),
                                //]
                            )
                        );
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
                // this add stall button triggers AddStallAction action.
                new StoreConnector<AppState, Store<AppState>>(
                  converter: (store) => store,
                  builder: (_, store){
                    return new FlatButton(
                      padding: new EdgeInsets.all(10.0),
                      onPressed: () async {
                        // pop up a textfield to for user to input stall name.
                        // We then create a Stall object based on the input.
                        Stall stall = await _addStallDialog();


                        // TRIGGER AddStallAction action, which takes in our newly created stall.
                        // The reducer will add this newly created stall and add it to our existing list
                        // of stalls. The reducer shd create a new state w new Order obj w new list of stalls.
                        //store.dispatch(new AddStallAction(stall: stall));
                        stalls.add(stall);
                        setState(() {});
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
                  return new FlatButton(
                    padding: new EdgeInsets.all(10.0),
                    onPressed: (){
                      //TRIGGER SubmitOrderAction.
                      Optional<Order> newOrder = store.state.currentOrder;
                      // The reducer shd create a new state w new Order. Then inform Firebase (async).
                     // store.dispatch(new OrderAction(order: newOrder));
                      Order order = new Order.empty(store.state.openOrderList[0]);
                      for (int i = 0; i < stalls.length; i++) {
                        for (int j = 0; j < stalls[i].dishes.length; j++) {
                          order = order.addDish(stalls[i].dishes[j], stalls[i].identifier);
                        }

                      }
                       store.dispatch(PlaceOrderAction(order));
                      // Navigate to a page to view ur order
                      Navigator.popAndPushNamed(context, '/HomePage');
                      print("Order placed.");
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

              ),


            ),
          ),

        ],
      ),
    );
  }
}

// This class constructs a card that represents a stall. When a user click 'Add Stalls' button,
// a new AddStallCard object will be created. It contains info such as the dish the user wants to
// order.
class AddStallCard extends StatefulWidget {
  final Stall stall;

  AddStallCard(this.stall);

  @override
  _AddStallCardState createState() => _AddStallCardState();
}

class _AddStallCardState extends State<AddStallCard> {

  /// This dialog shows up when +Add dish button is tapped. It returns Future<Dish> future when
  /// popped from Navigator.
  Future<Dish> _addDishDialog() {
    TextEditingController textEditingController = new TextEditingController();
    return showDialog<Dish>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Add dish"),
            content: new TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: "What's the dish you want to order?",
                  hintText: 'eg. butter chicken rice. Extra rice. '
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
                    Dish dish = new Dish(name: textEditingController.text);
                    Navigator.of(context).pop(dish); // When popped, the dish is wrapped in a Future
                                                     // object which is returned by this _addDishDialog().
                  },
                  child: new Text("Add")),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new Container(
        // bottom padding for the card
        padding: new EdgeInsets.only(bottom: 15.0),
        child: new Column(
          children: <Widget>[

            // The title of the card, which is the stall name
            new Container(
              color: new Color(0xFF9A9A9A),
              padding: new EdgeInsets.all(15.0),
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
                    child: new ListView.builder(
                        itemCount: widget.stall.dishes.isEmpty ? 0 :  widget.stall.dishes.length,
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
                    ),
                  ),

                  // This is the +Add dish button
                  new Row(
                    children: <Widget>[
                      new Padding(padding: new EdgeInsets.all(16.0)), // Just some space to the left.
                      new StoreConnector<AppState, Store<AppState>>(
                        converter: (store) => store,
                        builder: (_, store){
                          return new FlatButton(
                            padding: new EdgeInsets.all(10.0),
                            onPressed: () async {
                              // AddDishAction is dispatched. Create a new dish and add it to this
                              // particular stall. This addStallCard widget is rebuilt with the
                              // newly added dish.
                              Dish dish = await _addDishDialog();
                              // The reducer shd create new state w a new Order obj w new stall w one more dish.
                              //store.dispatch(new AddDishAction(stall: widget.stall, dish: dish));
                              widget.stall.dishes.add(dish);
                              setState((){});
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
      ),
    );
  }
}

