import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> writeActionReducer = combineReducers([
  TypedReducer<AppState,WriteAvailableHawkerCenterAction>(_writeAvailableHawkerCenterReducer),
  TypedReducer<AppState,WriteAvailableOpenOrderAction>(_writeAvailableOpenOrderReducer),
  TypedReducer<AppState,SelectHawkerCenterAction>(_selectHawkerCenterReducer),
  TypedReducer<AppState,WriteCurrentDeliveryAction>((state,action) => 
    state.copyWith(currentDeliveryList: action.toWrite)),
  TypedReducer<AppState,WriteCurrentOrderAction>((state,action) => 
    state.copyWith(currentOrder: action.toWrite)),
  TypedReducer<AppState,ChangeAppStatusAction>((state,action) =>
    state.copyWith(currentAppStatus: action.toWrite))
]);

final Reducer<AppState> _writeAvailableHawkerCenterReducer = (state,action) {
  print(action.toWrite);
  return state.copyWith(availableHawkerCenter: action.toWrite);
};

final Reducer<AppState> _writeAvailableOpenOrderReducer = (state,action) {
  return state.copyWith(openOrderList: action.toWrite);
};

final Reducer<AppState> _selectHawkerCenterReducer = (state,action) {
  return state.copyWith(currentHawkerCenter: action.toWrite);
};
