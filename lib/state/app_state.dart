import 'package:quiver/core.dart';
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
  final CombinedDeliveryList currentDeliveryList;

  AppState copyWith({
    User currentUser,
    AppStatusFlags currentAppStatus,
    List<HawkerCenter> availableHawkerCenter,
    HawkerCenter currentHawkerCenter,
    List<OrderDetail> openOrderList,
    Order currentOrder,
    CombinedDeliveryList currentDeliveryList
  }) {
    return new AppState._internal(
      currentUser: currentUser ?? this.currentUser,
      currentAppStatus: currentAppStatus ?? this.currentAppStatus,
      availableHawkerCenter: availableHawkerCenter ?? this.availableHawkerCenter,
      currentHawkerCenter: currentHawkerCenter ?? this.currentHawkerCenter.orNull,
      openOrderList: openOrderList ?? this.openOrderList,
      currentOrder: currentOrder ?? this.currentOrder.orNull,
      currentDeliveryList: currentDeliveryList ?? this.currentDeliveryList
    );
  }

  AppState._internal({
    @required User currentUser,
    @required AppStatusFlags currentAppStatus,
    @required List<HawkerCenter> availableHawkerCenter,
    @required HawkerCenter currentHawkerCenter,
    @required List<OrderDetail> openOrderList,
    @required Order currentOrder,
    @required CombinedDeliveryList currentDeliveryList
  }): this.currentUser = currentUser,
    this.currentAppStatus = currentAppStatus,
    this.availableHawkerCenter = availableHawkerCenter,
    this.currentHawkerCenter = Optional.fromNullable(currentHawkerCenter),
    this.openOrderList = openOrderList,
    this.currentOrder = Optional.fromNullable(currentOrder),
    this.currentDeliveryList = currentDeliveryList;

  AppState.initial():
      this.currentUser = new User.initial(),
      this.currentAppStatus = AppStatusFlags.unauthenticated,
      this.availableHawkerCenter = new List<HawkerCenter>(),
      this.currentHawkerCenter = Optional<HawkerCenter>.absent(),
      this.openOrderList = new List<OrderDetail>(),
      this.currentOrder = Optional<Order>.absent(),
      this.currentDeliveryList = new CombinedDeliveryList.absent();
}
