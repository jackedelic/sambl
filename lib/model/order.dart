import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';

export 'package:sambl/model/hawker_center.dart';


class Dish {
  bool isPriceSpecified;
  final double price;
  final String name;


  //Constructor
  Dish({this.name, this.price}) {
    isPriceSpecified = this.price == null ? false : true;
  }
  bool equals(Dish other) {
    return this.name == other.name;
  }

  Dish.withPrice(String name, double price): this.name = name, this.price = price, this.isPriceSpecified = true;

  Dish.withOutPrice(String name): this.name = name, this.price = 0.0, this.isPriceSpecified = false;

  @override
  String toString() {
    if (!isPriceSpecified) {
      return 'dish: ' + name;
    } else {
      return 'dish: ' + name + ' ' + price.toString();
    }
  }

}

/// Construct a stall that consists primarily of a list of [dishes] sold at this stall.
/// A stall also has a [name].
class Stall {
  static const double deliveryFeePerExtraStall = 0.6;
  static const double deliveryFeePerExtraDish = 0.3;

  final HawkerCenterStall identifier;
  /// The list of dishes associated with this particular stall.
  final List<Dish> dishList;

  /// [identifier] is the HawkerCenterStall obj. dishList is a list of Dish objs.
  Stall({this.identifier, this.dishList });

  /// Construct a stall whose dishList consists of one dish.
  Stall.one({this.identifier, dish}) : this.dishList = [dish];

  Stall addDish(Dish dish) {
    return new Stall(identifier: this.identifier, dishList: this.dishList + [dish]);
  }

  Stall removeDish(Dish dish) {
    return new Stall(identifier: this.identifier, dishList: this.dishList.where((currentDish) => !currentDish.equals(dish)));
  }

  bool notEmpty() {
    return this.dishList.isNotEmpty;
  }

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

  @override
  String toString() {
    String res = '(';
    res += identifier.toString();
    res += ' : [';
    dishList.forEach((dish) => res += (dish.toString() + ', '));
    res += '])';
    return res;
  }
}

class Order {
  static const double baseDeliveryfee = 1.0;
  static const double deliveryFeePerExtraStall = 0.6;



  final List<Stall> stallList;
  final OrderDetail orderDetail;
  Order(List<Stall> list, OrderDetail detail): this.stallList = list, this.orderDetail = detail;
  
  Order.empty(OrderDetail detail): this.orderDetail = detail, this.stallList = new List<Stall>();


  Order addDish(Dish dish, HawkerCenterStall stallIdentifier) {
    if (stallList.map((stall) => stall.identifier).any((identifier) => identifier.equals(stallIdentifier))) {
      return new Order(this.stallList.map<Stall>((stall){
        return ((stall.identifier.equals(stallIdentifier)) ? stall.addDish(dish) : stall);
      }), this.orderDetail);
    } else {
      return new Order(this.stallList + [new Stall.one(identifier: stallIdentifier, dish: dish)], this.orderDetail);
    }
  }

  Order removeDish(Dish dish, HawkerCenterStall stallIdentifier) {
    return new Order(this.stallList.map<Stall>((stall){
      return ((stall.identifier.equals(stallIdentifier)) ? stall.removeDish(dish) : stall);
    }).where((stall) => stall.notEmpty()), this.orderDetail);
  }
  
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

  @override
  String toString() {
    String res = orderDetail.toString() + ' : ';
    stallList.forEach((stall) => res = res + (stall.toString()) + ', ');
    return res;
  }

}