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
import 'package:sambl/state/app_state.dart';
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

  TextEditingController pickUpPtController = new TextEditingController();
  TextEditingController closingTimeController = new TextEditingController();
  TextEditingController etaController = new TextEditingController();
  TextEditingController remarkController = new TextEditingController();

  OrderDetail orderDetail = new OrderDetail();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    pickUpPtController = new TextEditingController();
    closingTimeController = new TextEditingController();
    etaController = new TextEditingController();
    remarkController = new TextEditingController();

    orderDetail = new OrderDetail();
    _tabController.addListener(() {
      setState(() {}); // change the state of the icon button
    });
  }

  /// button to navigate to the next tab. In the last tab (tab controller's index == 2), the button when pressed
  ///  brings deliverer to 'delivery subscribers' page.
  Widget _buildNextButton() {

    return new StoreProvider<AppState>(
      store: store,
      child: new StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (_, store) {
          return new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                  onPressed: (){
                    if (_tabController.index != 2) {
                      _tabController.animateTo((_tabController.index + 1) % 3);
                    } else {
//                      OrderDetail newOrderDetail = new OrderDetail(
//                          pickupPoint: pickUpPtController.text,
//                          hawkerCenter: , closingTime: null, eta: null, maxNumberofDishes: null)
//                      store.dispatch(action);
                      Navigator.popAndPushNamed(context, '/OrdererListPage');
                    }

                  },
                  child: _tabController.index != 2 ? new Icon(Icons.arrow_forward_ios, color: MyColors.mainRed,) :
                  new Container(
                    decoration: new BoxDecoration(
                        border: new Border.all(width: 1.0, color: MyColors.mainRed),
                        borderRadius: new BorderRadius.circular(8.0)

                    ),
                    padding: new EdgeInsets.all(6.0),
                    child: new Text("Confirm",
                      style: new TextStyle(
                          color: MyColors.mainRed,
                          fontSize: 17.0
                      ),
                    ),
                  )
              )
            ],
          );
        },
      ),
    );

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
                      new CreateOpenOrderMainLayout(pickUpPtController, closingTimeController, etaController),

                      // The layout that asks deliverer to specify number of dishes to deliver
                      // and any additional remarks.
                      new CreateOpenOrderRemarkLayout(orderDetail),

                      // The last 'confirmation' layout which shows a summary of the openOrder details
                      new CreateOpenOrderConfirmLayout(pickUpPtController, closingTimeController, etaController, remarkController, orderDetail),
                    ]
                ),
              ),


              // Some space in between the list of 'nearby places' above and the arrow button
              // This Padding widget may have diff padding value than the next page - 'create_open_order_remark_page'
              // for the purpose of fixing the arrow button and icons at the bottom to the same
              // position in the two pages.
              new Padding(padding: new EdgeInsets.all(5.0),),

              // The Arrow BUTTON to navigate to 'additional remark/confirmation page' when pressed.
              // Arrow button becomes confirm button in confirmation page. At this point, when confirm button is pressed,
              // deliverer will be navigated to 'subscribers page'.
              _buildNextButton(),


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