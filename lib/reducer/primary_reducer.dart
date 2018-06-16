import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/action/deliver_action.dart';
import 'package:sambl/action/order_action.dart';
import 'package:sambl/action/payment_action.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/reducer/authentication_reducer.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> primaryReducer = combineReducers([
  TypedReducer<AppState,AuthenticationAction>(authenticationReducer),
  TypedReducer<AppState,DeliverAction>(deliverReducer),
  TypedReducer<AppState,OrderAction>(orderReducer),
  TypedReducer<AppState,PaymentAction>(paymentReducer),
]);

final Reducer<AppState> deliverReducer = combineReducers([]);

final Reducer<AppState> orderReducer = combineReducers([]);

final Reducer<AppState> paymentReducer = combineReducers([]);

