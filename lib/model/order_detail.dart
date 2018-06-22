import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/model/hawker_center.dart';

class OrderDetail {
  final GeoPoint pickupPoint;
  final HawkerCenter hawkerCenter;
  final String delivererUid;
  final DateTime closingTime;
  final DateTime eta;
  final String remarks;
  final int maxNumberofDishes;
  final int remainingNumberofDishes;

  OrderDetail({
    @required this.pickupPoint,
    @required this.hawkerCenter,
    @required this.delivererUid,
    @required this.closingTime,
    @required this.eta,
    @required this.remarks,
    @required this.maxNumberofDishes,
    @required this.remainingNumberofDishes
  });

  @override 
  String toString() {
    return '(' +  this.pickupPoint.toString() + ', ' + this.hawkerCenter.toString() + ', ' 
      + this.delivererUid + ', ' + this.closingTime.toString() + ', ' + this.eta.toString()
      + ', ' + this.eta.toString() + ', ' + this.remarks + ', ' + this.maxNumberofDishes.toString() 
      + ', ' + this.remainingNumberofDishes.toString() + ')';
  }
}