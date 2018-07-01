import 'dart:async';
import 'package:redux/redux.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/reset_action.dart';
import 'dart:io' show Platform;

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
    print(message['aps']['alert']);
    return null;
    //return secondaryHandler[message['aps']['']].call(message,store);
  } else {
    return null;
  }
}

void _orderRejectedMessageHandler (Map<String,dynamic> message, Store<AppState> store) async {
  print('Order rejected by deliverer');
  store.dispatch(new ResetAction());
}

void _orderApprovedMessageHandler (Map<String,dynamic> message, Store<AppState> store) async {
  print('The deliverer has approved your order');
}