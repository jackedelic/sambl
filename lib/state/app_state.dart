import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

import 'package:sambl/model/delivery_list.dart';
import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/user.dart';
import 'package:sambl/utility/app_status_flag.dart';

export 'package:sambl/model/delivery_list.dart';
export 'package:sambl/model/hawker_center.dart';
export 'package:sambl/model/order.dart';
export 'package:sambl/model/order_detail.dart';
export 'package:sambl/model/hawker_center.dart';
export 'package:sambl/model/user.dart';
export 'package:sambl/utility/app_status_flag.dart';

enum AppStateFields {
  availableHawkerCenter,
  currentHawkerCenter,
  openOrderList,
  currentOrder,
  currentDeliveryList
}

class AppState {

  final User currentUser;
  final AppStatusFlags currentAppStatus;
  
  final List<HawkerCenter> availableHawkerCenter;
  final Optional<HawkerCenter> currentHawkerCenter;
  final List<OrderDetail> openOrderList;
  final Optional<Order> currentOrder;
  final DeliveryList currentDeliveryList;

  AppState modify(AppStateFields fieldToModify,dynamic newValue) {
    switch(fieldToModify) {
      case AppStateFields.availableHawkerCenter:
        assert(newValue is List<HawkerCenter>);
        return new AppState._internal(
          currentUser: this.currentUser,
          currentAppStatus: this.currentAppStatus,
          availableHawkerCenter: newValue,
          currentHawkerCenter: this.currentHawkerCenter,
          openOrderList: this.openOrderList,
          currentOrder: this.currentOrder,
          currentDeliveryList: this.currentDeliveryList);
        break;
      case AppStateFields.currentDeliveryList:
        assert(newValue is DeliveryList);
        return new AppState._internal(
          currentUser: this.currentUser,
          currentAppStatus: this.currentAppStatus,
          availableHawkerCenter: this.availableHawkerCenter,
          currentHawkerCenter: this.currentHawkerCenter,
          openOrderList: this.openOrderList,
          currentOrder: this.currentOrder,
          currentDeliveryList: newValue);
        break;
      case AppStateFields.currentHawkerCenter:
        assert(newValue is HawkerCenter);
        return new AppState._internal(
          currentUser: this.currentUser,
          currentAppStatus: this.currentAppStatus,
          availableHawkerCenter: this.availableHawkerCenter,
          currentHawkerCenter: Optional.of(newValue),
          openOrderList: this.openOrderList,
          currentOrder: this.currentOrder,
          currentDeliveryList: this.currentDeliveryList);
        break;
      case AppStateFields.currentOrder:
        assert(newValue is Order);
        return new AppState._internal(
          currentUser: this.currentUser,
          currentAppStatus: this.currentAppStatus,
          availableHawkerCenter: this.availableHawkerCenter,
          currentHawkerCenter: this.currentHawkerCenter,
          openOrderList: this.openOrderList,
          currentOrder: Optional<Order>.of(newValue),
          currentDeliveryList: this.currentDeliveryList);
        break;
      case AppStateFields.openOrderList:
        assert (newValue is List<OrderDetail>);
        return new AppState._internal(
          currentUser: this.currentUser,
          currentAppStatus: this.currentAppStatus,
          availableHawkerCenter: this.availableHawkerCenter,
          currentHawkerCenter: this.currentHawkerCenter,
          openOrderList: newValue,
          currentOrder: this.currentOrder,
          currentDeliveryList: this.currentDeliveryList);
        break;
      default:
        return this;
    }
  }

  AppState._internal({
    @required User currentUser,
    @required AppStatusFlags currentAppStatus,
    @required List<HawkerCenter> availableHawkerCenter,
    @required Optional<HawkerCenter> currentHawkerCenter,
    @required List<OrderDetail> openOrderList,
    @required Optional<Order> currentOrder,
    @required DeliveryList currentDeliveryList
  }): this.currentUser = currentUser,
    this.currentAppStatus = currentAppStatus,
    this.availableHawkerCenter = availableHawkerCenter,
    this.currentHawkerCenter = currentHawkerCenter,
    this.openOrderList = openOrderList,
    this.currentOrder = currentOrder,
    this.currentDeliveryList = currentDeliveryList;

  AppState.unauthenticated():
      this.currentUser = new User.initial(),
      this.currentAppStatus = AppStatusFlags.unauthenticated,
      this.availableHawkerCenter = new List<HawkerCenter>(),
      this.currentHawkerCenter = Optional<HawkerCenter>.absent(),
      this.openOrderList = new List<OrderDetail>(),
      this.currentOrder = Optional<Order>.absent(),
      this.currentDeliveryList = new DeliveryList.absent();

  AppState.awaitingSignUp(): 
      this.currentUser = new User.initial(),
      this.currentAppStatus = AppStatusFlags.awaitingSignup,
      this.availableHawkerCenter = new List<HawkerCenter>(),
      this.currentHawkerCenter = Optional<HawkerCenter>.absent(),
      this.openOrderList = new List<OrderDetail>(),
      this.currentOrder = Optional<Order>.absent(),
      this.currentDeliveryList = new DeliveryList.absent();
  
  AppState.authenticated(User user):
      this.currentUser = user,
      this.currentAppStatus = AppStatusFlags.authenticated,
      this.availableHawkerCenter = new List<HawkerCenter>(),
      this.currentHawkerCenter = Optional<HawkerCenter>.absent(),
      this.openOrderList = new List<OrderDetail>(),
      this.currentOrder = Optional<Order>.absent(),
      this.currentDeliveryList = new DeliveryList.absent();

  AppState.ordering(User user, Order currentOrder):
      this.currentUser = user,
      this.currentAppStatus = AppStatusFlags.ordering,
      this.availableHawkerCenter = new List<HawkerCenter>(),
      this.currentHawkerCenter = Optional<HawkerCenter>.of(currentOrder.orderDetail.hawkerCenter),
      this.openOrderList = new List<OrderDetail>(),
      this.currentOrder = Optional<Order>.of(currentOrder),
      this.currentDeliveryList = new DeliveryList.absent();

  AppState.delivering(User user, DeliveryList currentDelivery): 
      assert(currentDelivery.deliveryDetail.isPresent),
      this.currentUser = user,
      this.currentAppStatus = AppStatusFlags.delivering,
      this.availableHawkerCenter = new List<HawkerCenter>(),
      this.currentHawkerCenter = Optional<HawkerCenter>.of(currentDelivery.deliveryDetail.value.hawkerCenter),
      this.openOrderList = new List<OrderDetail>(),
      this.currentOrder = Optional<Order>.absent(),
      this.currentDeliveryList = currentDelivery;
}
