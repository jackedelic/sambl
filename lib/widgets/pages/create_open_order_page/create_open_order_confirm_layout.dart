import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/hawker_center.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/main.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/quantity_display.dart';
/// This class constructs the layout for confirmation page for creating open order. This layout
/// would be the last tabbarview child in the 'create open order page'.
/// This layout gives a summary of the open order created by the user and wrap all the information
/// provided in the previous two tabs (tabbarview children) in [OrderDetail].
/// This layout uses redux to dispatch DeliverAction with OpenOrder obj.
class CreateOpenOrderConfirmLayout extends StatefulWidget {
  TextEditingController remarkController = new TextEditingController();
  TextEditingController pickUpPtController = new TextEditingController();
  TextEditingController closingTimeController = new TextEditingController();
  TextEditingController etaController = new TextEditingController();
  OrderDetail orderDetail;
  CreateOpenOrderConfirmLayout(this.pickUpPtController, this.closingTimeController, this.etaController, this.remarkController, this.orderDetail);

  @override
  _CreateOpenOrderConfirmLayoutState createState() => _CreateOpenOrderConfirmLayoutState();
}

class _CreateOpenOrderConfirmLayoutState extends State<CreateOpenOrderConfirmLayout> {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new Column(
          children: <Widget>[

            // Title: Delivery Summary
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              decoration: new BoxDecoration(
                  border: new Border.all(color: MyColors.borderGrey, width: 1.8),
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
              child: new Center(
                child: new Text("Summary",
                  style: new TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),

            new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0)),
            // The summary body
            new Container(
              height: 270.0,
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              padding: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                  border: new Border.all(color: MyColors.borderGrey, width: 1.8),
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
              child: new ListView(
                children: <Widget>[
                  // This row shows the pickup point.
                  // Borderless container.
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text("Picking up at ${widget.pickUpPtController.text}",
                            style: new TextStyle(
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // some space between 'pickup pt' row and 'other details' row
                  new Padding(
                    padding: new EdgeInsets.symmetric(vertical: 10.0),
                  ),

                  // This row shows the 'order closing time', 'eta' and 'num of dishes to deliver'.
                  // Borderless container
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        // This wid rep closing time
                        new QuantityDisplay(
                          head: new QuantityDisplayElement(
                            content: "closing in",
                          ),
                          quantity: new QuantityDisplayElement(
                              content: "${widget.closingTimeController.text}"
                          ),
                          tail: new QuantityDisplayElement(
                              content: "min"
                          ),
                        ),


                        // This wid rep eta
                        new QuantityDisplay(
                          head: new QuantityDisplayElement(
                            content: "ETA",
                          ),
                          quantity: new QuantityDisplayElement(
                              content: "${widget.etaController.text}"
                          ),
                          tail: new QuantityDisplayElement(
                              content: "min"
                          ),
                        ),


                        // This wid rep number of dishes to deliver.
                        new QuantityDisplay(
                          head: new QuantityDisplayElement(
                            content: "Delivering",
                          ),
                          quantity: new QuantityDisplayElement(
                              content: "${widget.orderDetail.maxNumberofDishes}"
                          ),
                          tail: new QuantityDisplayElement(
                              content: "dishes"
                          ),
                        ),

                      ],
                    ),
                  ),

                  // Some space btwn 'additional detail' and the prev 'quantity display' row.
                  new Padding(
                      padding: new EdgeInsets.symmetric(vertical: 10.0)
                  ),
                  // This last part shows the additional remark
                  new Container(
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Text("Additional Remarks: ",
                              style: new TextStyle(
                                  fontSize: 18.0
                              ),
                            )
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Text("${widget.remarkController.text}",
                                style: new TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),

          ],
        )
    );
  }
}