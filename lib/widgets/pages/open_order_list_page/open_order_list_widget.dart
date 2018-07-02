import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/bottom_icon.dart';
/// This class is widget class wrapping the JioEntry obj. The resulting widget is what is gonna
/// be displayed onto our jio list page. We wrap it in an Expansion tile.
class OpenOrderListWidget extends StatefulWidget {
  final OrderDetail openOrder;

  OpenOrderListWidget(this.openOrder);

  @override
  _OpenOrderListWidgetState createState() => new _OpenOrderListWidgetState();
}

class _OpenOrderListWidgetState extends State<OpenOrderListWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
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
                child: new Text("${widget.openOrder.delivererUid}",
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

                      ),
                      new Text("min",
                        style: new TextStyle(
                            fontSize: 15.0
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
       
//      new Text("${widget.jioEntry.hawkerName} (closing in ${new DateTime.now().difference(widget.jioEntry.closingTime).inMinutes} mins)")
//        children: <Widget>[
//          new ListTile(
//            title: new Text("Pick up pt: ${widget.jioEntry.pickupPoint}"),
//          ),
//          new ListTile(
//            title: new Text("ETA: ${widget.jioEntry.eta.hour}:${widget.jioEntry.eta.minute}"),
//          ),
//          new ListTile(
//            title: new Text("Jio created by ${widget.jioEntry.jioCreator}"),
//          )
//        ],
        // The items to display when the tile expands
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Text("Pick up location: Cafe Agora(Yale-Nus)"),

              // This container holds only the place order button
              new Container(
                margin: new EdgeInsets.only(top: 50.0, bottom: 10.0, right: 15.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new PlaceOrderButton(), // custom button, defined below this class.
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


// This class constructs a 'place order' button in each expansion Tile
class PlaceOrderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
        padding: new EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.pushNamed(context, '/PlaceOrderPage');
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