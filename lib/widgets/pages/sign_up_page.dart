import 'package:flutter/material.dart';

import 'package:sambl/widgets/shared/my_button.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/main.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/firestore_write_action.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/async_action/google_authentication.dart';
import 'package:sambl/action/write_action.dart';
import 'package:sambl/utility/firebase_reader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/**
 * This class creates sign up page.
 */
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  //final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
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

         // SamBl title
         new Positioned(
             top: 150.0,
             left: 50.0,
             right: 50.0,
             child: new Center(
               child: new Text("Sambl",
                 style: new TextStyle(
                     color: Colors.white,
                     fontSize: 80.0
                 ),
               ),
             )
         ),
         // Sign In With Google button
         new Positioned(
           bottom: 50.0,
           left: 50.0,
           right: 50.0,
           child: new Container(
               height: 60.0,
               child: new StoreConnector<AppState,VoidCallback>(
                   converter: (store) => () async {

                     store.dispatch(registerUserAction);
                     // store.dispatch(new SelectHawkerCenterAction(store.state.availableHawkerCenter[0]));
                     // print(store.state.currentHawkerCenter.value);
                     // store.dispatch(new CreateOpenOrderAction(new OrderDetail(
                     //   maxNumberofDishes: 7,
                     //   closingTime: new DateTime.now().add(new Duration(hours: 2,minutes: 15)),
                     //   eta: new DateTime.now().add(new Duration(hours: 3)),
                     //   pickupPoint: new GeoPoint(1.4, 103.02547),
                     //   remarks: "first order to be submitted",
                     //   hawkerCenter: store.state.currentHawkerCenter.value
                     // )));
                     // store.dispatch(new CloseOpenOrderAction());
                     //store.dispatch(signOutAction);
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

                     // print(store.state.currentDeliveryList);
                     if (store.state.currentAppStatus == AppStatusFlags.unauthenticated) {
                       print("inside sign in page: not authenticated");

                     } else if (store.state.currentAppStatus == AppStatusFlags.authenticated){
                       print("authenticated! going to home page");
                       print("inside sign in page (going to homepage), list is ${store.state.openOrderList}");
                       Navigator.pushNamed(context, '/HomePage');
                     } else {
                       print("inside sign in page, neither authenticated nor unauthenticated, status: ${store.state.currentAppStatus}");
                     }
                   },
                   builder: (context,callback) => Material(
                     color: MyColors.mainRed,
                     borderRadius: new BorderRadius.circular(30.0),
                     child: new InkWell(
                        borderRadius: new BorderRadius.circular(30.0),
                        splashColor: MyColors.mainBackground,
                         child: new Center(
                           child: new Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               const Text("G",
                                 style: const TextStyle(
                                     fontFamily: "Futura",
                                     fontSize: 40.0,
                                     color: Colors.white
                                 ),
                               ),
                               // vertical divider
                               new Container(
                                 margin: new EdgeInsets.symmetric(horizontal: 10.0),
                                 height: 40.0,
                                 width: 1.5,
                                 color: Colors.white,
                               ),
                               const Text("SIGN UP WITH GOOGLE",
                                 style: const TextStyle(
                                   fontSize: 18.0,
                                   color: Colors.white,
                                 ),
                                 textAlign: TextAlign.center,
                               ),
                             ],
                           ),
                         ),
                         onTap: callback
                     ),
                   )

               )
           ),
         )
       ],
     ),
   );
  }
}
