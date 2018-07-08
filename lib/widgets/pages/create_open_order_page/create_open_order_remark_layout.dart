import 'package:flutter/material.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/bottom_icon.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/order_action.dart';
import 'package:sambl/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
/// This is the layout shown when the user (deliverer) has filled the 'Pick Up point', 'Order Closing
/// Time' and 'ETA' on the prev layout (create_open_order_main_layout).
/// This page requires the deliverer to do two things - 1. specify the number of dishes to deliver and
/// 2. additional remarks about the delivery.

class CreateOpenOrderRemarkLayout extends StatefulWidget {

  /// Constructor that receives the OpenOrder.
  CreateOpenOrderRemarkLayout() {

  }

  @override
  _CreateOpenOrderRemarkLayoutState createState() => _CreateOpenOrderRemarkLayoutState();
}

class _CreateOpenOrderRemarkLayoutState extends State<CreateOpenOrderRemarkLayout> {
  int _numOfDishes;

  @override
  void initState() {
    _numOfDishes = 3;
  } // number of dishes to deliver


  @override
  Widget build(BuildContext context) {
    return new ListView(
          children: <Widget>[
            // number selector to select the number of dishes to deliver.
            new Container(
              padding: new EdgeInsets.symmetric(horizontal: 0.0),
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  border: new Border.all(color: MyColors.borderGrey ,width: 1.8),
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0))
              ),
              child: new Row(
                children: <Widget>[
                  // This is the label 'Number of dishes to deliver'.
                  new Expanded(
                    flex: 2,
                      child: new Text("Number of dishes to deliver:",
                        style: new TextStyle(
                          fontSize: 16.0,
                          height: 1.0
                        ),
                      ),
                  ),

                  // This is the number selector consisting of three elements (two buttons and a number in btwn)
                  // e.g '+ 3 -'.
                  new Expanded(
                    flex: 1,
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // The Increment button
                        new Expanded(
                          flex: 5,
                          child: new ScopedModelDescendant<Info>(
                            builder: (context, child, info) {
                              return new IconButton(
                                icon: new Icon(Icons.add),
                                onPressed: (){
                                  // edit oiur info model
                                  info.editInfo(maxNumberofDishes: ++_numOfDishes);
                                },
                              );
                            },
                          ),
                        ),

                        // The number representing the number of dishes to deliver.
                        new Expanded(
                          flex: 3,
                          child: new ScopedModelDescendant<Info>(
                            builder: (context, child, info){
                              return new Text("${info.maxNumberofDishes}",
                                style: new TextStyle(
                                    fontSize: 16.0
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),

                        // The decrement button
                        new Expanded(
                          flex: 5,
                          child: new ScopedModelDescendant<Info>(
                            builder: (context, child, info){
                              return new IconButton(
                                icon: new Icon(Icons.remove),
                                onPressed: (){
                                  // edit our info model
                                  setState(() {
                                   info.editInfo(maxNumberofDishes:  _numOfDishes == 0 ? _numOfDishes : --_numOfDishes);
                                  });

                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  )

                ],

              ),
            ),

            // Just some space between the two rows - 'number of dishes to deliver'
            // and 'additional remarks input textfield'.
            new Padding(padding: new EdgeInsets.all(5.0)),

            // This is the additional remark TextField. It's the big box.
            new Container(
              padding: new EdgeInsets.symmetric(horizontal: 0.0),
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  border: new Border.all(color: MyColors.borderGrey ,width: 1.8),
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
              ),
//              height: 200.0,
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new ScopedModelDescendant<Info>(
                  builder: (context, child, info) {
                    return new TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: new InputDecoration(
                          hintText: 'I never underdeliver.',
                          labelText: "Additional remarks"
                      ),
                      onChanged: (text) {
                        info.editInfo(remarks: text);
                      },
                    );
                  },
                )

                ),
              ),

          ],
        );


  }
}
