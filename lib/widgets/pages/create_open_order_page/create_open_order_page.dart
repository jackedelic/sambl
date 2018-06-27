import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/order_action.dart'; // Action
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'create_open_order_main_layout.dart';
import 'create_open_order_remark_layout.dart';
import 'package:sambl/widgets/shared/bottom_icon.dart';

///This page represents the page a user navigates to when he select 'deliver' button in the home page
class CreateOpenOrderPage extends StatefulWidget {
  @override
  _CreateOpenOrderPageState createState() => _CreateOpenOrderPageState();
}

class _CreateOpenOrderPageState extends State<CreateOpenOrderPage> with SingleTickerProviderStateMixin {
TabController _tabController;

@override
void initState() {
  _tabController = new TabController(length: 2, vsync: this);
  _tabController.addListener(() {
      setState(() {

      });

  });
}

@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar().build(context),
      backgroundColor: MyColors.mainBackground,
      body: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          height: MediaQuery.of(context).size.height, // max out the height and then
          // constrained by specified margin
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
              color: Colors.white
          ),
          child: new ListView(
            children: <Widget>[
              // title like -> [Deliver from: FoodClique(NUS)]
              new Container(
                margin: new EdgeInsets.symmetric(vertical: 10.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text("Delivering from:",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 20.0
                        ),

                      ),
                    )
                  ],
                ),
              ),

              // TabBarViews for the layouts - main, remark
              new Container(
                height: 320.0,
                child: new TabBarView(
                  controller: _tabController,
                    children: <Widget>[
                      // The layout that asks deliverer to input pickup pt, closing time and eta.
                      new CreateOpenOrderMainLayout(),

                      // The layout that ases deliverer to specify number of dishes to deliver
                      // and any additional remarks.
                      new CreateOpenOrderRemarkLayout(),
                    ]
                ),
              ),


              // Some space in between the list of 'nearby places' above and the arrow button
              // This Padding widget may have diff padding value than the next page - 'create_open_order_remark_page'
              // for the purpose of fixing the arrow button and icons at the bottom to the same
              // position in the two pages.
              new Padding(padding: new EdgeInsets.all(5.0),),

              // The Arrow BUTTON to navigate to 'delivery_remark_page' when pressed.
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlatButton(
                      onPressed: (){
                        _tabController.animateTo((_tabController.index + 1) % 2);
                      },
                      child: new Icon(Icons.arrow_forward_ios, color: MyColors.mainRed,))
                ],
              ),

              // some space btwn 'arrow button' and 'bottom icon'
              new Padding(
                padding: new EdgeInsets.all(10.0),
              ),

              // The bottom icons
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new BottomIcon(pageNum: _tabController.index + 2),
                ],
              )


            ],
          )
      ),



    );
  }
}
