import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';

class WriteAction {
  
}

class WriteAvailableHawkerCenterAction extends WriteAction {
  List<HawkerCenter> toWrite;

  WriteAvailableHawkerCenterAction(List<HawkerCenter> list): this.toWrite = list;
}

class WriteAvailableOpenOrderAction extends WriteAction{
  List<OrderDetail> toWrite;

  WriteAvailableOpenOrderAction(List<OrderDetail> list): this.toWrite = list;
}