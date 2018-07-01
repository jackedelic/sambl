import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/action/deliver_action.dart';
import 'package:sambl/action/order_action.dart';
import 'package:sambl/action/payment_action.dart';
import 'package:sambl/action/write_action.dart';
import 'package:sambl/action/reset_action.dart';

import 'package:sambl/reducer/authentication_reducer.dart';
import 'package:sambl/reducer/write_action_reducer.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> primaryReducer = combineReducers([
  TypedReducer<AppState,AuthenticationAction>(authenticationReducer),
  TypedReducer<AppState,DeliverAction>(deliverReducer),
  TypedReducer<AppState,OrderAction>(orderReducer),
  TypedReducer<AppState,PaymentAction>(paymentReducer),
  TypedReducer<AppState,WriteAction>(writeActionReducer),
  TypedReducer<AppState,ResetAction>(_resetActionReducer),
]);

final Reducer<AppState> deliverReducer = combineReducers([]);

final Reducer<AppState> orderReducer = combineReducers([]);

final Reducer<AppState> paymentReducer = combineReducers([]);

AppState _resetActionReducer(AppState state, dynamic action) {
  return new AppState.authenticated(state.currentUser);
}

