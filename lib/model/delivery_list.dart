import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';

class DeliveryList {
  final Map<String,Order> orders;
  
  DeliveryList({
    @required this.orders,
    @required detail
  });

  DeliveryList.absent(): this.orders = Map<String,Order>();

  Map<String,dynamic> toJson() => {
    'orders': this.orders
  };

}

class CombinedDeliveryList {
  final DeliveryList pending;
  final DeliveryList approved;
  final Optional<OrderDetail> deliveryDetail;
  
  CombinedDeliveryList({
    @required this.pending,
    @required this.approved,
    @required Optional<OrderDetail> detail
  }): this.deliveryDetail = detail;

  CombinedDeliveryList.absent(): 
    this.pending = new DeliveryList.absent(), this.approved = new DeliveryList.absent(),
    this.deliveryDetail = Optional<OrderDetail>.absent();

  CombinedDeliveryList copyWith({
    DeliveryList pending,
    DeliveryList approved,
    OrderDetail detail,
  }) {
    return new CombinedDeliveryList(
      pending: pending ?? this.pending,
      approved: approved ?? this.approved,
      detail: Optional.fromNullable(detail) ?? this.deliveryDetail
    );
  }

  Map<String,dynamic> toJson() => {
    'pending': this.pending.toJson(),
    'approved': this.approved.toJson(),
    'detail': this.deliveryDetail.transform((detail) => detail.toJson()).orNull
  };

}