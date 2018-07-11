import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
import 'package:sambl/widgets/pages/create_open_order_page_deprecated/create_open_order_page.dart';
import 'package:sambl/widgets/pages/home_page/home_page.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_page.dart';
import 'package:sambl/widgets/pages/place_order_page/place_order_page.dart';
import 'package:sambl/widgets/pages/orderer_list_page/orderer_list_page.dart';
import 'package:sambl/widgets/pages/sign_in_page.dart';
import 'package:sambl/widgets/pages/sign_up_page.dart';
import 'package:sambl/widgets/pages/start_page.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/reducer/primary_reducer.dart';
import 'package:sambl/message_handler/primary_handler.dart';
import 'package:sambl/middleware/runnabl_action_middleware.dart';

import 'package:sambl/widgets/shared/my_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sambl/middleware/write_logger_middleware.dart';


// store is made global since there is only one store in our entire app. We can thus access this
// store by importing this main.dart file.



final Store<AppState> store = new Store<AppState>(
  primaryReducer, /* Function defined in the reducers file */
  initialState: new AppState.initial(),
  middleware: [thunkMiddleware,runnableActionMiddleware,writeLoggerMiddleware],
);

void main() {
  runApp(new MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (message) => primaryMessageHandler(message,HandlerType.onMessage,store),
      onLaunch: (message) => primaryMessageHandler(message,HandlerType.onLaunch,store),
      onResume: (message) => primaryMessageHandler(message,HandlerType.onResume,store)
    );

    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primaryColor: MyColors.mainRed,
          primarySwatch: MyColors.mainRedSwatches, // When ExpansionTile expands, the text turns this color
          inputDecorationTheme: new InputDecorationTheme( // TextField deco color (baseline, labelText etc)
            fillColor: MyColors.mainRed,
          )
        ),
        home: new StartPage(),
        routes: <String, WidgetBuilder> {
          "/CreateOpenOrderPageDeprecated" : (BuildContext context) => new CreateOpenOrderPageDeprecated(),
          "/HomePage" : (BuildContext context) => new HomePage(),
          "/OpenOrderListPage" : (BuildContext context) => new OpenOrderListPage(),
          "/PlaceOrderPage" : (BuildContext context) => new PlaceOrderPage(),
          "/SignInPage" : (BuildContext context) => new SignInPage(),
          "/SignUpPage" : (BuildContext context) => new SignUpPage(),
          "/CreateOpenOrderPage": (BuildContext context) => new CreateOpenOrderPage(),
          "/OrdererListPage" : (BuildContext context) => new OrdererListPage(),
        },
      )
    );
  }
}
