import 'package:redux/redux.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/reset_action.dart';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sambl/action/write_action.dart';
import 'package:quiver/core.dart';

abstract class FirestoreWriteAction {

  void run(Store<AppState> store) {

  }
}

class PlaceOrderAction implements FirestoreWriteAction {
  final Order toWrite;

  PlaceOrderAction(Order order): toWrite = order;

  void run(Store<AppState> store) async {
    Optional.fromNullable(
      await CloudFunctions.instance.call(functionName: "placeOrder",
      parameters: this.toWrite.toJson()))
      .ifPresent((orderId) {
        print(orderId);
        FirebaseMessaging().subscribeToTopic(orderId);
        store.dispatch(new WriteCurrentOrderAction(toWrite));
      });
  }
}

class CreateOpenOrderAction implements FirestoreWriteAction {
  final OrderDetail toWrite;

  CreateOpenOrderAction(OrderDetail detail): toWrite = detail;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "createOpenOrder",parameters: this.toWrite.toJson());
  }
}

class CloseOrderAction implements FirestoreWriteAction {
  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "closeOrder");
  }
}

class ApproveOrderAction implements FirestoreWriteAction{
  final String toWrite;
  
  ApproveOrderAction(String id): toWrite = id;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "approveOrder",parameters: {"id": toWrite});
  }
}

class RejectOrderAction implements FirestoreWriteAction{
  final String toWrite;
  
  RejectOrderAction(String id): toWrite = id;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "rejectOrder",parameters: {"id": toWrite});
  }
}

class FinalizeDeliveryAction implements FirestoreWriteAction{
  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "finalizeDelivery");
    store.dispatch(new ResetAction());
  }
}