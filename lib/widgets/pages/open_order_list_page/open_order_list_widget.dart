import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/place_order_page/place_order_page.dart';
/// This class is widget class wrapping the JioEntry obj. The resulting widget is what is gonna
/// be displayed onto our jio list page. We wrap it in an Expansion tile.
class OpenOrderListWidget extends StatefulWidget {
  final OrderDetail orderDetail;

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
          backgroundColor: Colors.white,
          title: new Container(
            child: new Row(
              children: <Widget>[
                // This is the left item - the name of deliverer
                new Container(
                  width: 200.0,
                  child: new Text("${widget.orderDetail.delivererUid}",
                    style: new TextStyle(
                        fontSize: 20.0,
                    ),
                  ),
                ),
                // This is the right items - the closing time, eta, num of dishes
                new Row(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text("25",
                          style: new TextStyle(
                              fontSize: 20.0
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          // The items to display when the tile expands
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Text("Pick up location: ${widget.orderDetail.pickupPoint}"),

                // This container holds only the place order button
                new Container(
                  margin: new EdgeInsets.only(top: 50.0, bottom: 10.0, right: 15.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new PlaceOrderButton(orderModel), // custom button, defined below this class.
                    ],
                  ),
                )
              ],
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