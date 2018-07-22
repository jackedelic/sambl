import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';

final Reducer<AppState> writeActionReducer = combineReducers([
  TypedReducer<AppState,WriteAvailableHawkerCenterAction>(_writeAvailableHawkerCenterReducer),
  TypedReducer<AppState,WriteAvailableOpenOrderAction>(_writeAvailableOpenOrderReducer),
  TypedReducer<AppState,SelectHawkerCenterAction>(_selectHawkerCenterReducer),
  TypedReducer<AppState,WriteCurrentOrderAction>((state,action) => 
    state.copyWith(currentOrder: action.toWrite)),
  TypedReducer<AppState,ChangeAppStatusAction>((state,action) =>
    state.copyWith(currentAppStatus: action.toWrite)),
  TypedReducer<AppState,ClearPendingOrderAction>((state,action) => 
    state.copyWith(currentDeliveryList: state.currentDeliveryList
      .copyWith(pending: new DeliveryList.absent()))),
  TypedReducer<AppState,WriteChatMessagesAction>((state,action) => 
    state.copyWith(chats: action.toWrite))
]);

final Reducer<AppState> _writeAvailableHawkerCenterReducer = (state,action) {
  return state.copyWith(availableHawkerCenter: action.toWrite);
};

final Reducer<AppState> _writeAvailableOpenOrderReducer = (state,action) {
  return state.copyWith(openOrderList: action.toWrite);
};

final Reducer<AppState> _selectHawkerCenterReducer = (state,action) {
  print('selecting hawker center');
  return state.copyWith(currentHawkerCenter: action.toWrite);
};
