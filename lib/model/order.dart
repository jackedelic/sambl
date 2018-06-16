import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/utility/geo_point.dart';

class Dish {
  final bool isPriceSpecified;
  final double price;
  final String name;
}

class Stall {
  static const double deliveryFeePerExtraStall = 0.6;
  static const double deliveryFeePerExtraDish = 0.3;

  final List<Dish> dishList;

  double getDeliveryfee() {
    return deliveryFeePerExtraStall + deliveryFeePerExtraDish * (dishList.length - 1);
  }

  double getPrice() {
    if (dishList.every((dish) => dish.isPriceSpecified)) {
      return dishList.fold<double>(0.0,(sum,current) => sum + current.price);
    } else {
      throw new Exception('priceUnspecifiedException');
    }
  }
}

class Order {
  static const double baseDeliveryfee = 1.0;
  static const double deliveryFeePerExtraStall = 0.6;

  final List<Stall> stallList;
  OrderDetail orderDetail;
  

  Order();
  //Order._internal({}); 

  
  double getDeliveryfee() {
    return baseDeliveryfee + stallList.fold<double>(0.0,(sum,current) => current.getDeliveryfee()) - deliveryFeePerExtraStall;
  }

  double getPrice() {
    try {
      return stallList.fold<double>(0.0,(sum,current) => current.getPrice());
    } catch(error) {
      print('error');
      return 0.0;
    }
  }

}