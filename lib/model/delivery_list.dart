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
  final DeliveryList paid;
  final Optional<OrderDetail> deliveryDetail;
  
  CombinedDeliveryList({
    @required this.pending,
    @required this.approved,
    @required this.paid,
    @required OrderDetail detail
  }): this.deliveryDetail = Optional.fromNullable(detail);

  CombinedDeliveryList.absent(): 
    this.pending = new DeliveryList.absent(), 
    this.approved = new DeliveryList.absent(),
    this.paid = new DeliveryList.absent(),
    this.deliveryDetail = Optional<OrderDetail>.absent();

  CombinedDeliveryList copyWith({
    DeliveryList pending,
    DeliveryList approved,
    DeliveryList paid,
    OrderDetail detail,
  }) {
    return new CombinedDeliveryList(
      pending: pending ?? this.pending,
      approved: approved ?? this.approved,
      paid: paid ?? this.paid,
      detail: detail ?? this.deliveryDetail.orNull
    );
  }

  Map<String,dynamic> toJson() => {
    'pending': this.pending.toJson(),
    'approved': this.approved.toJson(),
    'paid': this.paid.toJson(),
    'detail': this.deliveryDetail.transform((detail) => detail.toJson()).orNull
  };

  @override
  String toString() {
    return this.toJson().toString();
  }

}