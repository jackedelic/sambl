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

abstract class WriteAction {
  final toWrite;
}

class WriteAvailableHawkerCenterAction implements WriteAction {
  final List<HawkerCenter> toWrite;

  WriteAvailableHawkerCenterAction(List<HawkerCenter> list): this.toWrite = list;
}

class WriteAvailableOpenOrderAction implements WriteAction {
  final List<OrderDetail> toWrite;

  WriteAvailableOpenOrderAction(List<OrderDetail> list): this.toWrite = list;
}

class WriteChatMessagesAction implements WriteAction {
  final Map<String,Conversation> toWrite;

  WriteChatMessagesAction(Map<String,Conversation> chats): this.toWrite = chats;
}

class SelectHawkerCenterAction implements RunnableAction, WriteAction {
  final bool reduceable = true;
  final HawkerCenter toWrite;

  SelectHawkerCenterAction(HawkerCenter center): this.toWrite = center;

  void run(Store<AppState> store) async {
    await CombinedSubscriber.instance().remove(name: 'openOrderListSubscription');
    CombinedSubscriber.instance().add(
      name: 'openOrderListSubscription', 
      subscription: toOpenOrderListSubscription(
        Firestore.instance.collection('hawker_centers').document(toWrite.uid), store)
    );
  }
}

class WriteCurrentDeliveryAction {
  final DeliveryList pending;
  final DeliveryList approved;
  final DeliveryList paid;
  final OrderDetail detail;

  WriteCurrentDeliveryAction({
    this.pending,
    this.approved,
    this.paid,
    this.detail
  });
}

class WriteCurrentOrderAction implements WriteAction {
  final Order toWrite;

  WriteCurrentOrderAction(Order order): this.toWrite = order;
 }

class ChangeAppStatusAction implements WriteAction {
  final AppStatusFlags toWrite;

  ChangeAppStatusAction(AppStatusFlags newFlag): this.toWrite = newFlag;
}

class ClearPendingOrderAction implements WriteAction {
  void toWrite;
}

class SetLocationAction implements WriteAction {
  final GeoPoint toWrite;

  SetLocationAction({this.toWrite});
}