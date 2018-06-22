import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/utility/geo_point.dart';

class Dish {
  bool isPriceSpecified;
  final double price;
  final String name;

  //Constructor
  Dish({this.name, this.price}) {
    isPriceSpecified = this.price == null ? false : true;
  }

}

/// Construct a stall that consists primarily of a list of [dishes] sold at this stall.
/// A stall also has a [name].
class Stall {
  static const double deliveryFeePerExtraStall = 0.6;
  static const double deliveryFeePerExtraDish = 0.3;

  /// The list of dishes associated with this particular stall.
  final List<Dish> dishes;

  /// The name of the stall.
  /// e.g Cool Spot (snack stall in Terrace)
  final String name;

  // constructor
  Stall({this.name, this.dishes});


  double getDeliveryfee() {
    return deliveryFeePerExtraStall + deliveryFeePerExtraDish * (dishes.length - 1);
  }

  double getPrice() {
    if (dishes.every((dish) => dish.isPriceSpecified)) {
      return dishes.fold<double>(0.0,(sum,current) => sum + current.price);
    } else {
      throw new Exception('priceUnspecifiedException');
    }
  }
}

class Order {
  static const double baseDeliveryfee = 1.0;
  static const double deliveryFeePerExtraStall = 0.6;

  final List<Stall> stalls;
  OrderDetail orderDetail;
  

  Order({this.stalls, this.orderDetail});
  //Order._internal({}); 

  
  double getDeliveryfee() {
    return baseDeliveryfee + stalls.fold<double>(0.0,(sum,current) => current.getDeliveryfee()) - deliveryFeePerExtraStall;
  }

  double getPrice() {
    try {
      return stalls.fold<double>(0.0,(sum,current) => current.getPrice());
    } catch(error) {
      print('error');
      return 0.0;
    }
  }

}