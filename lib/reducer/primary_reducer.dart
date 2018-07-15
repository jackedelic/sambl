import 'package:redux/redux.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/action/payment_action.dart';
import 'package:sambl/action/write_action.dart';
import 'package:sambl/reducer/authentication_reducer.dart';
import 'package:sambl/reducer/write_action_reducer.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> primaryReducer = combineReducers([
  TypedReducer<AppState,AuthenticationAction>(authenticationReducer),
  TypedReducer<AppState,PaymentAction>(paymentReducer),
  TypedReducer<AppState,WriteAction>(writeActionReducer),
]);


final Reducer<AppState> paymentReducer = combineReducers([]);

