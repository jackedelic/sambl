import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/pages/place_order_page/place_order_page.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/quantity_display.dart';

class ViewOrderPage extends StatefulWidget {
  OrderModel orderModel;// when first navigated to this page, we use the orderModel
  // passed from placed_order_summary_page. When the real order from the database changes,
  // we replace the orderModel with the real order.

  ViewOrderPage(this.orderModel);

  @override
  _ViewOrderPageState createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().build(context),
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
                  child:  new Text("Delivering from",
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // This is the list of stalls
          // Each stall has a list of dishes.


          new Expanded(
              child: new ListView.builder(
                  itemCount: widget.orderModel.order.stalls?.length ?? 0,
                  itemBuilder: (BuildContext context, int n) {
                    print("inside stall card of view order page, stall[$n] is ${widget.orderModel.order.stalls[n]}");
                    return new StallCard( widget.orderModel.order.stalls[n]);

                  }
              )
          )


        ],
      ),
    );
  }
}
class StallCard extends StatelessWidget {
  Stall stall;

  StallCard(this.stall);

  @override
  Widget build(BuildContext context) {
    return new Container(
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
                   new Text(stall.identifier.name,
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
                    child: new ScopedModelDescendant<OrderModel>(

                      builder: (context, child, orderModel) {
                        print("inside list of dishes, dishes.length is ${stall.dishes.isEmpty ? 0 :  stall.dishes.length}");
                        return new ListView.builder(
                          itemCount: stall.dishes?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                          // A column consists of the string for stall name and a divider.
                            return new Column(
                              children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                       new Expanded(
                                        child: new Container(
                                          padding: new EdgeInsets.all(10.0) ,
                                          child: new Text(stall.dishes[index].name,
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
                ]
              )
            )
          ]
        )
      );
    }
}
