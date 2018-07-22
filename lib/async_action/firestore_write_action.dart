import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/action/authentication_action.dart';
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
  final String orderId;
  final Order updatedOrder;
  
  ApproveOrderAction(String id, Order order): this.orderId = id, this.updatedOrder = order;

  void run(Store<AppState> store) {
    assert(this.updatedOrder.validatePrice());
    CloudFunctions.instance.call(functionName: "approveOrder",parameters: {
      "id": this.orderId, 
      "stalls": updatedOrder.stalls.map((stall) => stall.toJson()).toList(),
      "price": updatedOrder.getPrice() + updatedOrder.getDeliveryfee()
    });
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

class AuthorizePaymentAction implements RunnableAction {
  final bool reduceable = false;

  void run(Store<AppState> store) async {
    CloudFunctions.instance.call(functionName: 'authorizePayment');
  }
}

final ThunkAction<AppState> registerUserAction = (Store<AppState> store) async {
  CloudFunctions.instance.call(functionName: "registerUser");
  await FirebaseAuth.instance.currentUser().then((user) => store.dispatch(LoginAction(new User(user,0))));
};

class RequestPayoutAction implements RunnableAction {
  final bool reduceable = false;
  final int amount;

  RequestPayoutAction(int amount): this.amount = amount;

  void run(Store<AppState> store) async {
    CloudFunctions.instance.call(functionName: 'requestPayout',parameters: {'amount': this.amount});
  }
}
