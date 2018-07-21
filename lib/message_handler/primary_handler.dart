/// note that this file is currently not in use but is kept for future features

import 'dart:io' show Platform;

import 'package:redux/redux.dart';

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
  if(Platform.isIOS) {
    return secondaryHandler[message['aps']['alert']].call(store);
  } else {
    return null;
  }
}

void _orderRejectedMessageHandler (Store<AppState> store) async {
}

void _orderApprovedMessageHandler (Store<AppState> store) async {
}