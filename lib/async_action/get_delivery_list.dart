import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';

final ThunkAction<AppState> getDeliveryListAction = (Store<AppState> store) async {
  print('test 3');
  FirebaseAuth.instance.currentUser().then((user) async {
    return Firestore.instance.collection('users').document(user.uid).get().then((snapshot) async {
      return new CombinedDeliveryList(
        pending: await deliveryListReader(snapshot.data['currentDelivery'],DeliveryListType.pending),
        approved: await deliveryListReader(snapshot.data['currentDelivery'],DeliveryListType.approved),
        detail: await snapshot.data['currentDelivery'].get().then((delivery) => orderDetailReader(delivery.data['detail']))
    );});
  }).then((list) => store.dispatch(WriteCurrentDeliveryAction(list)));
};