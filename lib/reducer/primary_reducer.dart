import 'package:redux/redux.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/action/write_action.dart';
import 'package:sambl/reducer/authentication_reducer.dart';
import 'package:sambl/reducer/write_action_reducer.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> primaryReducer = combineReducers([
  TypedReducer<AppState,AuthenticationAction>(authenticationReducer),
  TypedReducer<AppState,WriteAction>(writeActionReducer),
  TypedReducer<AppState,WriteCurrentDeliveryAction>((state,action) {
    if (action.approved != null) {
      return state.copyWith(currentDeliveryList: state.currentDeliveryList.copyWith(approved: action.approved));
    } else if (action.pending != null) {
      return state.copyWith(currentDeliveryList: state.currentDeliveryList.copyWith(pending: action.pending));
    } else if (action.paid != null) {
       return state.copyWith(currentDeliveryList: state.currentDeliveryList.copyWith(paid: action.paid));
    } else if (action.detail != null) {
      return state.copyWith(currentDeliveryList: state.currentDeliveryList.copyWith(detail: action.detail));
    }
  })
]);

