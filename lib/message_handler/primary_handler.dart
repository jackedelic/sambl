import 'dart:io' show Platform;

import 'package:redux/redux.dart';

import 'package:sambl/action/reset_action.dart';
import 'package:sambl/state/app_state.dart';

enum HandlerType {
  onMessage,
  onLaunch,
  onResume,
}

const Map<String,dynamic> secondaryHandler = {
  "order_rejected" : _orderRejectedMessageHandler,
  "order_approved" : _orderApprovedMessageHandler
};

dynamic primaryMessageHandler (Map<String,dynamic> message, HandlerType type, Store<AppState> store) {
  print(message);
  if(Platform.isIOS) {
    return secondaryHandler[message['aps']['alert']].call(store);
  } else {
    return null;
  }
}

void _orderRejectedMessageHandler (Store<AppState> store) async {
  print('Order rejected by deliverer');
  store.dispatch(new ResetAction());
}

void _orderApprovedMessageHandler (Store<AppState> store) async {
  print('The deliverer has approved your order');
}