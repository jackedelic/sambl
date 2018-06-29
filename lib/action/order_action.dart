import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';

class OrderAction {
  final Optional<Order> order;
  OrderAction({this.order});
}

class CreateNewOrderAction extends OrderAction {

}

class AddStallAction extends OrderAction {
  final Stall stall;
  AddStallAction({@required this.stall});
}


class AddDishAction extends OrderAction {
  // Each dish must come from a stall.
  final Stall stall;
  final Dish dish;

  /// Constructor
  AddDishAction({@required this.stall, @required this.dish});

}

class SubmitOrderAction extends OrderAction {

}