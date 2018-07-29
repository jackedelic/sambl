import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/widgets/shared/my_color.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:sambl/widgets/pages/place_order_page/place_order_page.dart';

import 'package:sambl/widgets/shared/quantity_display.dart';
/// This class is widget class wrapping the JioEntry obj. The resulting widget is what is gonna
/// be displayed onto our jio list page. We wrap it in an Expansion tile.
class OpenOrderListWidget extends StatefulWidget {
  final OrderDetail orderDetail;
  /// In the open_order_list_page (the prev page), we pass in orderDetail for this
  /// particular open order.
  OpenOrderListWidget(this.orderDetail);

  @override
  _OpenOrderListWidgetState createState() => new _OpenOrderListWidgetState();
}

class _OpenOrderListWidgetState extends State<OpenOrderListWidget> {
  OrderModel orderModel;


  @override
  void initState() {
    super.initState();
    orderModel = new OrderModel(order: Order.empty(widget.orderDetail));
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModel(
      model: orderModel,
      child: new Container(
        margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: Colors.white,
        child: new ExpansionTile(
          trailing: Container(width: 0.0,),
          backgroundColor: Colors.white,


          title: new Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              children: <Widget>[
                // This is the left item - the name of deliverer
                new Expanded(
                  flex: 2,
                  child: new Text("${widget.orderDetail.delivererName}",
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                // This is the right items - the closing time, eta, num of dishes
                new Expanded(
                  flex: 3,
                  child: new Row(
                    children: <Widget>[

                      // Closing in x mins
                      new QuantityDisplay(
                          head: new QuantityDisplayElement(
                            fontSize: 12.0,
                            content: "Closing in",
                          ),
                          quantity: new QuantityDisplayElement(
                              fontSize: 30.0,
                              content: "${widget.orderDetail.closingTime.difference(DateTime.now()).inMinutes}"
                          ),
                          tail: new QuantityDisplayElement(
                              fontSize: 12.0,
                              content: "mins"
                          )
                      ),

                      // Arriving in y mins
                      new QuantityDisplay(
                          head: new QuantityDisplayElement(
                            fontSize: 12.0,
                            content: "Arriving in",
                          ),
                          quantity: new QuantityDisplayElement(
                              fontSize: 30.0,
                              content: "${widget.orderDetail.eta.difference(DateTime.now()).inMinutes}"
                          ),
                          tail: new QuantityDisplayElement(
                              fontSize: 12.0,
                              content: "mins"
                          )
                      ),

                      // Carrying x dishes
                      new QuantityDisplay(
                          head: new QuantityDisplayElement(
                            fontSize: 12.0,
                            content: "Carrying",
                          ),
                          quantity: new QuantityDisplayElement(
                              fontSize: 30.0,
                              content: "${widget.orderDetail.maxNumberofDishes}"
                          ),
                          tail: new QuantityDisplayElement(
                              fontSize: 12.0,
                              content: "dishes"
                          )
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),

          // The items to display when the tile expands
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: new Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: new FutureBuilder<String>(
                        future: reverseGeocode(widget.orderDetail.pickupPoint),
                        builder: (_, AsyncSnapshot<String> snapshot){

                          if (snapshot.hasData) {
                            return new Text("Pick up location: ${snapshot.data}",
                              style: const TextStyle(
                                  fontSize: 18.0
                              ),
                            );
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return new Text("Loading pick up location",
                              style: const TextStyle(
                                  fontSize: 18.0
                              ),
                            );
                          } else {
                              return new Text("Error",
                              style: const TextStyle(
                                  fontSize: 18.0
                              ),
                            );
                          }
                        }
                    ),
                  ),


                  // This container holds only the place order button
                  new Container(
                    margin: new EdgeInsets.only(top: 50.0, bottom: 20.0, right: 15.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new ScopedModelDescendant<OrderModel>(
                            builder: (context, child, orderModel) {
                              return new PlaceOrderButton(orderModel);
                            }
                        ), // custom button, defined below this class.
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// This class constructs a 'place order' button in each expansion Tile
class PlaceOrderButton extends StatelessWidget {
  OrderModel orderModel;

  PlaceOrderButton(this.orderModel);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
        padding: new EdgeInsets.all(0.0),
        onPressed: () {
          // Tell 'PlaceOrderPage' about this delivererUid
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return new PlaceOrderPage(orderModel);
                  }
              )
          );
        },
        child: new Container(
          padding: new EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: MyColors.borderGrey ,width: 1.8),
              borderRadius: new BorderRadius.all(new Radius.circular(10.0))
          ),
          child: new Text("Place order"),
        )
    );
  }
}

/// This is the model used only within each open_order_list_widget (unique for each widget), and passed down the widget
/// tree
class OrderModel extends Model {
  Order order;

  OrderModel({this.order});

  void editOrderModel({order}) {
    this.order = order;
    notifyListeners();
  }

}