import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order_detail.dart';

export 'package:sambl/model/hawker_center.dart';

class Dish {
  bool isPriceSpecified;
  final double price;
  final String name;


  //Constructor deprecated
  Dish({this.name, this.price}) {
    isPriceSpecified = this.price == null ? false : true;
  }
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

/// Construct a stall that consists primarily of a list of [dishes] sold at this stall.
/// A stall also has a [name].
class Stall {
  static const double deliveryFeePerExtraStall = 0.6;
  static const double deliveryFeePerExtraDish = 0.3;

  final HawkerCenterStall identifier;
  /// The list of dishes associated with this particular stall.
  final List<Dish> dishes;


  /// [identifier] is the HawkerCenterStall obj. dishList is a list of Dish objs.
  Stall({this.identifier, this.dishes});

  /// Construct a stall whose dishList consists of one dish.
  Stall.one({this.identifier, dish}) : this.dishes = [dish];

  Stall addDish(Dish dish) {
    return new Stall(identifier: this.identifier, dishes: this.dishes + [dish]);
  }

  Stall removeDish(Dish dish) {
    return new Stall(identifier: this.identifier, dishes: this.dishes.where((currentDish) => !currentDish.equals(dish)));
  }

  bool notEmpty() {
    return this.dishes.isNotEmpty;
  }

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

  Map<String,dynamic> toJson() => {
    'identifier': identifier.toJson(),
    'dishes' : dishes.map<Map<String,dynamic>>((dish) => dish.toJson()).toList()
  };

  int count() {
    return dishes.length;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}

class Order {
  static const double baseDeliveryfee = 1.0;
  static const double deliveryFeePerExtraStall = 0.6;

  final List<Stall> stalls;
  final OrderDetail orderDetail;
  final bool isPaid;
  Order(List<Stall> list, OrderDetail detail,{bool isPaid = false}): 
    this.stalls = list, this.orderDetail = detail, this.isPaid = isPaid;
  
  Order.empty(OrderDetail detail): 
    this.orderDetail = detail, this.stalls = new List<Stall>(), this.isPaid = false;


  Order addDish(Dish dish, HawkerCenterStall stallIdentifier) {
    if (stalls.map((stall) => stall.identifier).any((identifier) => identifier.equals(stallIdentifier))) {
      return new Order(this.stalls.map<Stall>((stall){
        return ((stall.identifier.equals(stallIdentifier)) ? stall.addDish(dish) : stall);
      }).toList(), this.orderDetail);
    } else {
      return new Order(this.stalls + [new Stall.one(identifier: stallIdentifier, dish: dish)], this.orderDetail);
    }
  }

  Order removeDish(Dish dish, HawkerCenterStall stallIdentifier) {
    return new Order(this.stalls.map<Stall>((stall){
      return ((stall.identifier.equals(stallIdentifier)) ? stall.removeDish(dish) : stall);
    }).where((stall) => stall.notEmpty()), this.orderDetail);
  }
  
  double getDeliveryfee() {
    return baseDeliveryfee + stalls.fold<double>(0.0,(sum,current) => sum + current.getDeliveryfee()) - deliveryFeePerExtraStall;
  }

  double getPrice() {
    try {
      return stalls.fold<double>(0.0,(sum,current) => sum + current.getPrice());
    } catch(error) {
      print('error');
      return 0.0;
    }
  }

  int count() {
    return stalls.fold<int>(0,(sum,current) => sum + current.count());
  }

  Map<String,dynamic> toJson() => {
    'stalls': stalls.map((stall) => stall.toJson()).toList(),
    'detail': this.orderDetail.toJson(),
    'dishCount': this.count()
  };

  @override
  String toString() {
    return this.toJson().toString();
  }

  
}

