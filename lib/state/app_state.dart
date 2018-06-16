import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sambl/model/delivery_list.dart';
import 'package:sambl/model/hawker_center.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/model/user.dart';
import 'package:sambl/utility/app_status_flag.dart';
import 'package:sambl/utility/geo_point.dart';

export 'package:sambl/model/delivery_list.dart';
export 'package:sambl/model/hawker_center.dart';
export 'package:sambl/model/order.dart';
export 'package:sambl/model/order_detail.dart';
export 'package:sambl/model/hawker_center.dart';
export 'package:sambl/model/user.dart';
export 'package:sambl/utility/app_status_flag.dart';
export 'package:sambl/utility/geo_point.dart';

class AppState {
  final User currentUser;
  final AppStatusFlags currentAppStatus;
  
  final List<HawkerCenter> availableHawkerCenter;
  final HawkerCenter currentHawkerCenter;
  final List<OrderDetail> openOrderList;
  final Order currentOrder;
  final DeliveryList currentDeliveryList;

  AppState._internal({
    this.currentAppStatus = AppStatusFlags.unauthenticated,
    this.currentUser = null,
    this.currentOrder = null,
    this.currentDeliveryList = null
  });

  factory AppState.initial() => new AppState._internal();
  factory AppState.loggedIn() => new AppState._internal(

  );
}
