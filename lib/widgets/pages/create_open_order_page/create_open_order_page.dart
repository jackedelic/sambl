import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_open_order_main_layout.dart';
import 'create_open_order_remark_layout.dart';
import 'package:sambl/widgets/shared/bottom_icon.dart';
import 'create_open_order_confirm_layout.dart';
import 'package:sambl/async_action/firestore_write_action.dart';


// temporary model used only within create_order_page folder
import 'package:sambl/model/order_detail.dart';

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
Info info;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      print("tab changes");
        info.notifyListeners(); // update the scopedModelDescendants on any new info.
        setState(() {}); // change the state of the icon button
    });

    //our scopedmodel
    info = new Info();

  }

  /// button to navigate to the next tab. In the last tab (tab controller's index == 2), the button when pressed
///  brings deliverer to 'delivery subscribers' page.
  Widget _buildNextButton() {
    if (_tabController.index != 2) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new FlatButton(
              onPressed: (){
                _tabController.animateTo((_tabController.index + 1) % 3);

              },
              child: new Icon(Icons.arrow_forward_ios, color: MyColors.mainRed,)

          )
        ],
      );
    }

    return Container(height: 0.0, width: 0.0,);


  }

  Widget _buildConfirmButton() {
    if (_tabController.index == 2) {
      return StoreConnector<AppState, Optional<HawkerCenter>>(
        converter: (store) => store.state.currentHawkerCenter,
        builder: (_, currentHawkerCenter) {
          return new ScopedModelDescendant<Info>(
            builder: (context, child , info){
              return new GestureDetector(
                onTap: () async {
                  if (info.closingTime == null || info.eta == null) {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Missing something?"),
                            content: new Text("${info.closingTime == null && info.eta == null ?
                            'you did not specify closing time and estimated time of arrival.' :
                            (info.closingTime == null ? 'Don\'t forget closing time.' : 'Don\'t forget estimated time of arrival.')
                            }"),
                          );
                        }
                    );
                  } else {
                    store.dispatch(new CreateOpenOrderAction(new OrderDetail(
                        maxNumberofDishes: info.maxNumberofDishes,
                        closingTime: info.closingTime,
                        eta: info.eta,
                        pickupPoint: info.pickupPoint,
                        remarks: "first order to be submitted",
                        hawkerCenter: currentHawkerCenter.value
                    )));
                    print("inside create_open_order_page, pressed confirm already. ");
                    Navigator.popAndPushNamed(context, '/OrdererListPage');
                  }

                },
                child: new Container(
                  margin: new EdgeInsets.only(top: 12.0),
                  decoration: new BoxDecoration(
                      color: info.closingTime == null && info.eta == null ? Colors.grey : MyColors.mainRed,
                      borderRadius: new BorderRadius.vertical(bottom: new Radius.circular(20.0))
                  ),
                  width: 344.0,
                  height: 50.0,
                  child: new Center(
                      child: new Text("Confirm",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        ),
                      )
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Container(height: 0.0, width: 0.0,);

  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<Info>(
      model: info,
      child: new Scaffold(
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
                        child: StoreConnector<AppState, Optional<HawkerCenter>>(
                          converter: (store) => store.state.currentHawkerCenter,
                          builder: (_, currentHawkerCenter) {
                            if (currentHawkerCenter.isPresent) {
                              return new Text("Delivering from: ${currentHawkerCenter.value.name}",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 18.0
                                ),

                              );
                            } else {
                              // display a text along the lines of "Select a fucking hawker center'
                              // but it is unnecessary since deliverer will not get to this page
                              // in the first place if he does not select a fucking hawker center.
                            }

                          },
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

                // The Arrow BUTTON to navigate to 'additional remark/confirmation page' when pressed.
                // Arrow button becomes confirm button in confirmation page. At this point, when confirm button is pressed,
                // deliverer will be navigated to 'subscribers page'.
                _buildNextButton(),


                // some space btwn 'arrow button' and 'bottom icon'
                new Padding(
                  padding: new EdgeInsets.all(5.0),

                ),

                // The bottom icons
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new BottomIcon(pageNum: _tabController.index + 2),
                  ],
                ),


                // This is the confirm button that only appears in the last tab
                _buildConfirmButton()


              ],
            )
        ),



      ),
    );
  }
}

// Model subclass used only within create_open_order_page
class Info extends Model {


  GeoPoint pickupPoint = new GeoPoint(1.2869369, 103.8437092);
  HawkerCenter hawkerCenter;
  String delivererUid;
  DateTime closingTime;
  DateTime eta;
  String remarks = "Hi, it's my pleasure to deliver for you.";
  int maxNumberofDishes = 3;
  int remainingNumberofDishes;
  String openOrderUid;

  /// create and return an OrderDetail object based on this info's attributes.
  OrderDetail getOrderDetail() {
    return new OrderDetail(
      pickupPoint: pickupPoint,
      hawkerCenter: hawkerCenter,
      delivererUid: delivererUid,
      closingTime: closingTime,
      eta: eta,
      remarks: remarks,
      maxNumberofDishes: maxNumberofDishes,
      remainingNumberofDishes: remainingNumberofDishes,
      openOrderUid: openOrderUid
    );
  }


  void editInfo({pickupPoint, hawkerCenter, delivererUid, closingTime, eta, remarks, maxNumberofDishes, remainingNumberofDishes, openOrderUid }){
    this.pickupPoint = pickupPoint ?? this.pickupPoint;
    this.hawkerCenter = hawkerCenter ?? this.hawkerCenter;
    this.delivererUid = delivererUid ?? this.delivererUid;
    this.closingTime = closingTime ?? (this.closingTime ?? DateTime.now());
    this.eta = eta ?? (this.eta ?? DateTime.now());
    this.remarks = remarks ?? "Hi, it's my pleasure to deliver for you.";
    this.maxNumberofDishes = maxNumberofDishes ?? this.maxNumberofDishes;
    this.remainingNumberofDishes = remainingNumberofDishes ?? this.remainingNumberofDishes;
    this.openOrderUid = openOrderUid ?? this.openOrderUid;

    notifyListeners();
  }

}