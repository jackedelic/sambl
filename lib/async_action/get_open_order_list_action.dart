import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';

final ThunkAction<AppState> getOpenOrderList = (Store<AppState> store) async {
  Firestore.instance.collection('open_orders').getDocuments()
    .then((collection) => collection.documents.where((document) => document.data['isOpen'] == true))
    .then((documents) => Stream.fromIterable(documents).asyncMap<OrderDetail>(
      (openOrder) async => await orderDetailReader(openOrder.reference)).toList())
    .then((openOrderList) => store.dispatch(
      new WriteAvailableOpenOrderAction(openOrderList)));
};