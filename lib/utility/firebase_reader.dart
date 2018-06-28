import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/delivery_list.dart';



Future<List<Stall>> stallListReader(List<dynamic> list) async {
  return new Stream.fromIterable(list).asyncMap<Stall>(
    (stall) async => new Stall(
      identifier: await hawkerCenterStallReader(stall['stallData']),
      dishes: stall['dishes'].map<Dish>((dish) => (dish['isPriceSpecified']) ?
          new Dish.withPrice(dish['name'],dish['price'].toDouble()) : 
          new Dish.withOutPrice(dish['name']))
          .toList()
    )
  ).toList();
}

Future<HawkerCenterStall> hawkerCenterStallReader(DocumentReference reference) async {
  return reference.get()
    .then((snapshot) => new HawkerCenterStall(name: snapshot['name']));
}

Future<HawkerCenter> hawkerCenterReader(DocumentReference reference) async {
  return reference.get()
    .then((snapshot) async => new HawkerCenter(
      snapshot['location'],
      snapshot['name'],
      await new Stream.fromIterable(snapshot['stalls'])
        .asyncMap((stall) => hawkerCenterStallReader(stall)).toList()
    ));
}

Future<OrderDetail> orderDetailReader(DocumentReference reference) async {
  return reference.get().then((snapshot) async =>
    new OrderDetail(
      closingTime: snapshot['closingTime'],
      delivererUid: snapshot['delivererUid'],
      eta: snapshot['eta'],
      hawkerCenter: await hawkerCenterReader(snapshot['hawkerCenter']),
      maxNumberofDishes: snapshot['maxNumberofDishes'],
      pickupPoint: snapshot['pickupPoint'],
      remainingNumberofDishes: snapshot['remainingNumberofDishes'],
      remarks: snapshot['remarks']
    )
  );
}

Future<Order> orderReader(DocumentReference reference) async {
  return reference.get()
    .then((snapshot) async {
      OrderDetail detail = await orderDetailReader(snapshot['orderDetail']);
      print(new Order(await stallListReader(snapshot['stalls']),detail));
      return new Order(await stallListReader(snapshot['stalls']),detail);
    });
}

Future<String> ordererUidReader(DocumentReference reference) async {
  return reference.get().then((snapshot) => snapshot['ordererUid']);
}

Future<DeliveryList> deliveryListReader(DocumentReference reference) async {
  return reference.get()
    .then((snapshot) async {
      return new DeliveryList(orders: new Map.fromEntries(
        await Stream.fromIterable(snapshot['orders'])
          .asyncMap<MapEntry<String,Order>>((order) async => 
          new MapEntry(await ordererUidReader(order), await orderReader(order)))
          .toList()
      ),
      detail: await orderDetailReader(snapshot['details']));
    });
}