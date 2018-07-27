import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/utility/geo_point_utilities.dart';

/// This class constructs open order created by the user.
class OrderDetail {
  final GeoPoint pickupPoint;
  final HawkerCenter hawkerCenter;
  final String delivererUid;
  final DateTime closingTime;
  final DateTime eta;
  final String remarks;
  int maxNumberofDishes;
  final int remainingNumberofDishes;
  final String openOrderUid;
  final String delivererName;
  final bool isOpen;

  OrderDetail({
    @required this.pickupPoint,
    @required this.hawkerCenter,
    this.delivererUid = "",
    @required this.closingTime,
    @required this.eta,
    this.remarks = "",
    @required this.maxNumberofDishes,
    this.remainingNumberofDishes = 0,
    this.openOrderUid = "",
    this.delivererName,
    this.isOpen = true
  });

  Map<String,dynamic> toJson() => {
    'pickupPoint': geoPointToMap(this.pickupPoint),
    'hawkerCenter': this.hawkerCenter.uid,
    'delivererUid': this.delivererUid,
    'closingTime': this.closingTime.toIso8601String(),
    'eta': this.eta.toIso8601String(),
    'remarks': this.remarks,
    'maxNumberofDishes': this.maxNumberofDishes,
    'openOrderUid': this.openOrderUid
  };

  @override 
  String toString() {
    return this.toJson().toString();
  }
}