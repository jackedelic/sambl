import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';

class DeliveryList {
  final Map<String,Order> orders;
  final Optional<OrderDetail> deliveryDetail;
  
  DeliveryList({
    @required this.orders,
    @required detail
  }): this.deliveryDetail = Optional<OrderDetail>.of(detail);

  DeliveryList.absent(): this.deliveryDetail = Optional<OrderDetail>.absent(), this.orders = Map<String,Order>();

}