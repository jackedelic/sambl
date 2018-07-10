import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';

import 'package:sambl/middleware/runnabl_action_middleware.dart';
import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/delivery_list.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/subscribers/combined_subscriber.dart';
import 'package:sambl/subscribers/subscription_converter.dart';

class WriteAction {
  
}

class WriteAvailableHawkerCenterAction extends WriteAction {
  final List<HawkerCenter> toWrite;

  WriteAvailableHawkerCenterAction(List<HawkerCenter> list): this.toWrite = list;
}

class WriteAvailableOpenOrderAction extends WriteAction{
  final List<OrderDetail> toWrite;

  WriteAvailableOpenOrderAction(List<OrderDetail> list): this.toWrite = list;
}

class SelectHawkerCenterAction implements RunnableAction {
  final HawkerCenter toWrite;

  SelectHawkerCenterAction(HawkerCenter center): this.toWrite = center;

  void run(Store<AppState> store) {
    CombinedSubscriber.instance().add(
      name: 'openOrderListSubscription', 
      subscription: toOpenOrderListSubscription(
        Firestore.instance.collection('hawker_centers').document(toWrite.uid), store)
    );
  }
}

class WriteCurrentDeliveryAction {
  final CombinedDeliveryList toWrite;

  WriteCurrentDeliveryAction(CombinedDeliveryList deliveryList): this.toWrite = deliveryList;
}

class WriteCurrentOrderAction {
  final Order toWrite;

  WriteCurrentOrderAction(Order order): this.toWrite = order;
 }

class ChangeAppStatusAction {
  final AppStatusFlags toWrite;

  ChangeAppStatusAction(AppStatusFlags newFlag): this.toWrite = newFlag;
}