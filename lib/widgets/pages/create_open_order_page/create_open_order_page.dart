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
import 'create_open_order_confirm_layout.dart';
/*
* TODO: Create Firebase instance to get the HawkerCentreStall name for the title of the page -> 'Delivering
* TODO: from The Terrace'.
* */
/// This page represents the page a user navigates to when he select 'deliver' button in the home page
/// This page does not use redux/store to deal with the OpenOrder obj created. Instead, new OpenOrder
/// obj is created when user navigates to a new layout(tab) based on the prev Open Order obj in the prev tab.
/// This means OpenOrder obj has to be passed to the new layout, and new Open Order obj is created
/// based on that old OpenOrder. This ensures that the state of the OpenOrder is handled in a purely
/// functional manner without going thru the store.
/// The reason we don't use redux is because we're creating an OpenOrder obj bit by bit, e.g create
/// Open Order obj with only pickup pt, eta, and closing time known, then only when we navigate to new
/// tab do we know the rest of the info such as num of dishes to deliver and remarks. If we are to
/// use redux, we have to create different actions corresponding to different creation phase of
/// OpenOrder obj. In other words, we don't want to use redux becus we don't want to create
/// those actions which correspond to diff creation phase of OpenOrder. We only want one CreateOpenOrderAction
/// and DeliverAction when using redux.
/// In the last layout/tab, the OpenOrder obj is dispatched with a DeliverAction using ofcourse redux.
class CreateOpenOrderPage extends StatefulWidget {

  @override
  _CreateOpenOrderPageState createState() => _CreateOpenOrderPageState();
}

class _CreateOpenOrderPageState extends State<CreateOpenOrderPage> with SingleTickerProviderStateMixin {
TabController _tabController;

@override
void initState() {
  _tabController = new TabController(length: 3, vsync: this);
  _tabController.addListener(() {
      setState(() {}); // change the state of the icon button
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

                      // The layout that asks deliverer to specify number of dishes to deliver
                      // and any additional remarks.
                      new CreateOpenOrderRemarkLayout(),

                      // The last 'confirmation' layout which shows a summary of the openOrder details
                      new CreateOpenOrderConfirmLayout(),
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
                        _tabController.animateTo((_tabController.index + 1) % 3);
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
