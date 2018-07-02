import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/async_action/google_authentication.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/main.dart';
import 'package:sambl/state/app_state.dart';

import 'package:sambl/utility/firebase_reader.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/async_action/get_available_hawker_center_action.dart';

import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';
import 'package:sambl/async_action/firestore_write_action.dart';

import 'package:sambl/action/write_action.dart';

import 'package:sambl/async_action/register_user_action.dart';

import 'package:sambl/async_action/get_open_order_list_action.dart';
import 'package:sambl/async_action/get_available_hawker_center_action.dart';

import 'package:sambl/async_action/get_delivery_list.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:sambl/action/write_action.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatelessWidget {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState,AppStatusFlags> (
    converter: (store) {
      // print("printing state: " + store.state.availableHawkerCenter.toString());
      return store.state.currentAppStatus;
    },
    builder: (context,status) {
      if (false ) {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
        return defaultPage(status);
      } else {
        return new Scaffold(
          key: _formKey,
          body: new Stack(
            children: <Widget>[
              new Container(
                color: Colors.black,  
                child: new Image(   
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black38,       
                  image: AssetImage('assets/images/sign_in_page_background.jpg'),
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  alignment: new FractionalOffset(0.0, 0.0),
                ),
              ),
              new Container (
                
                alignment: Alignment.bottomCenter,
                child: new AspectRatio(
                  aspectRatio: 2.5,
                  child: new Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new StoreConnector<AppState,VoidCallback>(
                          converter: (store) => () async {
                            // get hawker centers
                            //store.dispatch(getAvailableHawkerCenterAction);

                            // select
                            // print(store.state.currentHawkerCenter);
                            //store.dispatch(new SelectHawkerCenterAction(store.state.availableHawkerCenter[1]));
                            //print(store.state.currentHawkerCenter);

                            //print(store.state.currentHawkerCenter.value.uid);
                            //store.dispatch(getOpenOrderList);
                            //print(store.state.openOrderList.toString());

                            // store.dispatch(PlaceOrderAction(new 
                            //   Order.empty(store.state.openOrderList[0])
                            //   .addDish(new Dish.withPrice("Salted egg chicken rice", 4.5)
                            //     , store.state.currentHawkerCenter.value.stallList[0])
                            //   .addDish(new Dish.withPrice("Sweet and sour fish rice", 5.0)
                            //     , store.state.currentHawkerCenter.value.stallList[0])
                            //   .addDish(new Dish.withPrice("Egg Prata", 2.5)
                            //     , store.state.currentHawkerCenter.value.stallList[1])
                            //     ));

                            // store.dispatch(new CreateOpenOrderAction(new OrderDetail(
                            //   maxNumberofDishes: 7,
                            //   closingTime: new DateTime.now().add(new Duration(hours: 2,minutes: 15)),
                            //   eta: new DateTime.now().add(new Duration(hours: 3)),
                            //   pickupPoint: new GeoPoint(1.4, 103.02547),
                            //   remarks: "first order to be submitted",
                            //   hawkerCenter: store.state.currentHawkerCenter.value
                            // )));

                            store.dispatch(signInWithGoogleAction);
                            //FirebaseMessaging().requestNotificationPermissions();
                            //FirebaseMessaging().subscribeToTopic('xGgTP5yfC7oFRHJu9aNy');
                            print('test');
                            //store.dispatch();
                            //print(store.state.currentOrder.value.toJson());
                            
                            //store.dispatch(signOutAction);
                      
                            //store.dispatch(getDeliveryListAction);
                            //print(store.state.currentDeliveryList.toJson());
                            //store.dispatch(new FinalizeDeliveryAction());

                            //store.dispatch(new ApproveOrderAction(store.state.currentDeliveryList.approved.orders.keys.toList()[0]));

                            store.dispatch(registerUserAction);
                            if (store.state.currentAppStatus == AppStatusFlags.unauthenticated) {
                              print("inside sign in page: not authenticated");

                            } else if (store.state.currentAppStatus == AppStatusFlags.authenticated){
                              print("authenticated! going to home page");

                              store.dispatch(new SelectHawkerCenterAction(await hawkerCenterReader((Firestore.instance.collection('hawker_centers').document('64ceajXT6dpCHIf6J9pQ')))));
                              print("print: store.dispatch(new SelectHawkerCenterAction(await hawkerCenterReader((Firestore.instance.collection('hawker_centers').document('64ceajXT6dpCHIf6J9pQ')))));");

                              if (store.state.currentHawkerCenter.isPresent && store.state.openOrderList.isEmpty) {
                                store.dispatch(getOpenOrderList);

                              }
                              print("getOpenOrderList dispatched");
                              print("inside sign in page, list is ${store.state.openOrderList}");
                              //Navigator.pushNamed(context, '/HomePage');
                            } else {
                              print("${store.state.currentAppStatus}");
                            }
                          },
                          builder: (context,callback) => new FlatButton(
                            child: Container(
                              child: new Text("sign in"),
                              color: Colors.red,
                              height: 100.0,
                              width: double.infinity,
                            ),
                            onPressed: callback
                          )

                        )
                      ],
                    )
                  ),
                ),
              )
            ],
          ),
        );
      }
    }
  );

}