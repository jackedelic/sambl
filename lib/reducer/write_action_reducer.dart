import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> writeActionReducer = combineReducers([
  TypedReducer<AppState,WriteAvailableHawkerCenterAction>(_writeAvailableHawkerCenterReducer),
  TypedReducer<AppState,WriteAvailableOpenOrderAction>(_writeAvailableOpenOrderReducer),
]);

final Reducer<AppState> _writeAvailableHawkerCenterReducer = (state,action) {
  print(action.toWrite);
  return state.modify(AppStateFields.availableHawkerCenter, action.toWrite);
};

final Reducer<AppState> _writeAvailableOpenOrderReducer = (state,action) {
  return state.modify(AppStateFields.openOrderList, action.toWrite);
};