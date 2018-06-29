import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';

export 'package:sambl/model/hawker_center.dart';


class Dish {
  final bool isPriceSpecified;
  final double price;
  final String name;

  bool equals(Dish other) {
    return this.name == other.name;
  }

  Dish.withPrice(String name, double price): 
    this.name = name, this.price = price, this.isPriceSpecified = true;

  Dish.withOutPrice(String name): 
    this.name = name, this.price = 0.0, this.isPriceSpecified = false;

  @override
  String toString() {
    return this.toJson().toString();
  }

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'price': this.price,
    'isPriceSpecified': this.isPriceSpecified
  };

}

class Stall {
  static const double deliveryFeePerExtraStall = 0.6;
  static const double deliveryFeePerExtraDish = 0.3;

  final HawkerCenterStall identifier;
  final List<Dish> dishList;

  Stall(HawkerCenterStall identifier, List<Dish> dishList): 
    this.identifier = identifier, this.dishList = dishList;

  Stall.one(HawkerCenterStall identifier, Dish dish): 
    this.identifier = identifier, this.dishList = [dish];

  Stall addDish(Dish dish) {
    return new Stall(this.identifier, this.dishList + [dish]);
  }

  Stall removeDish(Dish dish) {
    return new Stall(this.identifier, this.dishList.where((currentDish) => !currentDish.equals(dish)));
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

  Map<String,dynamic> toJson() => {
    'identifier': identifier.toJson(),
    'dishes' : dishList.map<Map<String,dynamic>>((dish) => dish.toJson()).toList()
  };

  int count() {
    return dishList.length;
  }

  @override
  String toString() {
    return this.toJson().toString();
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
      return new Order(this.stallList + [new Stall.one(stallIdentifier,dish)], this.orderDetail);
    }
  }

  Order removeDish(Dish dish, HawkerCenterStall stallIdentifier) {
    return new Order(this.stallList.map<Stall>((stall){
      return ((stall.identifier.equals(stallIdentifier)) ? stall.removeDish(dish) : stall);
    }).where((stall) => stall.notEmpty()), this.orderDetail);
  }
  
  double getDeliveryfee() {
    return baseDeliveryfee + stallList.fold<double>(0.0,(sum,current) => sum + current.getDeliveryfee()) - deliveryFeePerExtraStall;
  }

  double getPrice() {
    try {
      return stallList.fold<double>(0.0,(sum,current) => sum + current.getPrice());
    } catch(error) {
      print('error');
      return 0.0;
    }
  }

  int count() {
    return stallList.fold<int>(0,(sum,current) => sum + current.count());
  }

  Map<String,dynamic> toJson() => {
    'stalls': stallList.map((stall) => stall.toJson()).toList(),
    'detail': this.orderDetail.toJson(),
    'dishCount': this.count()
  };

  @override
  String toString() {
    return this.toJson().toString();
  }

  
}

