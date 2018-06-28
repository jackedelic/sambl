import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/hawker_center.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/main.dart';

/// This class constructs the layout for confirmation page for creating open order. This layout
/// would be the last tabbarview child in the 'create open order page'.
/// This layout gives a summary of the open order created by the user and wrap all the information
/// provided in the previous two tabs (tabbarview children) in [OrderDetail].
/// This layout uses redux to dispatch DeliverAction with OpenOrder obj.
class CreateOpenOrderConfirmLayout extends StatefulWidget {

  @override
  _CreateOpenOrderConfirmLayoutState createState() => _CreateOpenOrderConfirmLayoutState();
}

class _CreateOpenOrderConfirmLayoutState extends State<CreateOpenOrderConfirmLayout> {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new ListView(
          children: <Widget>[

            // This row shows the pickup point.
            new Container(
              child: new Row(
                children: <Widget>[

                ],
              ),
            ),

            // This row shows the 'order closing time', 'eta' and 'num of dishes to deliver'.
            new Container(
              child: new Row(
                children: <Widget>[

                ],
              ),
            ),



          ],
        )
    );
  }
}
