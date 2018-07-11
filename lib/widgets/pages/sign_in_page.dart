import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


import 'package:sambl/async_action/google_authentication.dart';
import 'package:sambl/state/app_state.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/async_action/firestore_write_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sambl/async_action/sign_out.dart';

class SignInPage extends StatelessWidget {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState,AppStatusFlags> (
    converter: (store) {
      return store.state.currentAppStatus;
    },
    builder: (context,status) {
      if (false/*status != AppStatusFlags.unauthenticated*/) {
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
                      margin: new EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.bottomCenter,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new StoreConnector<AppState,VoidCallback>(
                          converter: (store) => () async {
                            // store.dispatch(signInWithGoogleAction);
                            // store.dispatch(new SelectHawkerCenterAction(store.state.availableHawkerCenter[0]));
                            // print(store.state.currentHawkerCenter.value);
                            store.dispatch(new CreateOpenOrderAction(new OrderDetail(
                              maxNumberofDishes: 7,
                              closingTime: new DateTime.now().add(new Duration(hours: 2,minutes: 15)),
                              eta: new DateTime.now().add(new Duration(hours: 3)),
                              pickupPoint: new GeoPoint(1.4, 103.02547),
                              remarks: "first order to be submitted",
                              hawkerCenter: store.state.currentHawkerCenter.value
                            )));
                            // store.dispatch(new CloseOpenOrderAction());
                            // store.dispatch(signOutAction);
                            // print(store.state.currentAppStatus);

                            // store.dispatch(PlaceOrderAction(new 
                            //   Order.empty(store.state.openOrderList[0])
                            //   .addDish(new Dish.withPrice("Salted egg chicken rice", 4.5)
                            //     , store.state.currentHawkerCenter.value.stallList[0])
                            //   .addDish(new Dish.withPrice("Sweet and sour fish rice", 5.0)
                            //     , store.state.currentHawkerCenter.value.stallList[0])
                            //   .addDish(new Dish.withPrice("Egg Prata", 2.5)
                            //     , store.state.currentHawkerCenter.value.stallList[1])
                            //     ));

                            // store.dispatch(new ApproveOrderAction(store.state.currentDeliveryList.pending.orders.keys.toList()[0]));
                            // store.dispatch(new ReportDeliveryAction(store.state.currentDeliveryList.approved.orders.keys.toList()[0]));

                            print(store.state.currentDeliveryList);
                          },
                          builder: (context,callback) => new FlatButton(
                            child: Container(
                              child: new Center(
                                child: new Text("sign in",
                                  style: new TextStyle(fontSize: 30.0),
                                ),
                              ),
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