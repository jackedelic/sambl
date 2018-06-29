
import 'package:cloud_functions/cloud_functions.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/state/app_state.dart';

final ThunkAction<AppState> createOpenOrderAction = (Store<AppState> store) async {
  store.state.currentDeliveryList.deliveryDetail.ifPresent((order) {
    CloudFunctions.instance.call(functionName: "createOpenOrder", parameters: order.toJson());
  });
};
