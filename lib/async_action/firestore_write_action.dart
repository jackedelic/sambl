import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/middleware/runnabl_action_middleware.dart';
import 'package:sambl/state/app_state.dart';

class PlaceOrderAction implements RunnableAction {
  final bool reduceable = false;
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

class CreateOpenOrderAction implements RunnableAction {
  final bool reduceable = false;
  final OrderDetail toWrite;

  CreateOpenOrderAction(OrderDetail detail): toWrite = detail;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "createOpenOrder",parameters: this.toWrite.toJson());
  }
}

class CloseOpenOrderAction implements RunnableAction {
  final bool reduceable = false;

  void run(Store<AppState> store) {
    store.dispatch(new ClearPendingOrderAction());
    CloudFunctions.instance.call(functionName: "closeOpenOrder");
  }
}

class ApproveOrderAction implements RunnableAction {
  final bool reduceable = false;
  final String toWrite;
  
  ApproveOrderAction(String id): toWrite = id;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "approveOrder",parameters: {"id": toWrite});
  }
}

class RejectOrderAction implements RunnableAction {
  final bool reduceable = false;
  final String toWrite;
  
  RejectOrderAction(String id): toWrite = id;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "rejectOrder",parameters: {"id": toWrite});
  }
}

class ReportDeliveryAction implements RunnableAction {
  final bool reduceable = false;
  final String toWrite;
  
  ReportDeliveryAction(String id): toWrite = id;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "reportDelivery",parameters: {"id": toWrite});
  }
}