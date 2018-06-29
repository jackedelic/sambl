import 'package:redux/redux.dart';
import 'package:sambl/state/app_state.dart';

import 'package:cloud_functions/cloud_functions.dart';

abstract class FirestoreWriteAction {

  void run(Store<AppState> store) {

  }
}

class PlaceOrderAction implements FirestoreWriteAction {
  final Order toWrite;

  PlaceOrderAction(Order order): toWrite = order;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "placeOrder",parameters: this.toWrite.toJson());
  }
}

class CreateOpenOrderAction implements FirestoreWriteAction {
  final OrderDetail toWrite;

  CreateOpenOrderAction(OrderDetail detail): toWrite = detail;

  void run(Store<AppState> store) {
    CloudFunctions.instance.call(functionName: "placeOrder",parameters: this.toWrite.toJson());
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