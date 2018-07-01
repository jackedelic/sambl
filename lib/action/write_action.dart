import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/delivery_list.dart';
import 'package:sambl/model/order.dart';

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

class SelectHawkerCenterAction extends WriteAction {
  final HawkerCenter toWrite;

  SelectHawkerCenterAction(HawkerCenter center): this.toWrite = center;
}

class WriteCurrentDeliveryAction {
  final CombinedDeliveryList toWrite;

  WriteCurrentDeliveryAction(CombinedDeliveryList deliveryList): this.toWrite = deliveryList;
}

class WriteCurrentOrderAction {
  final Order toWrite;

  WriteCurrentOrderAction(Order order): this.toWrite = order;
 }