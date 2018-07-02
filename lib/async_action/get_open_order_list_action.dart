import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';

final ThunkAction<AppState> getOpenOrderList = (Store<AppState> store) async {
  print('test 2');
  Firestore.instance.collection('hawker_centers')
    .document("64ceajXT6dpCHIf6J9pQ")
    .collection('open_orders').getDocuments()
    .then((collection) => 
      collection.documents.map<String>((document) => document.documentID))
    .then((documentIds) => Stream.fromIterable(documentIds).asyncMap<OrderDetail>(
      (openOrderID) async {
        print(openOrderID);
        return await orderDetailReader(Firestore.instance.collection('open_orders').document(openOrderID));
      }).toList())
    .then((openOrderList){
      print("gonna dispatch writeAvailableOpenOrderAction(openOrderList)");
      store.dispatch(new WriteAvailableOpenOrderAction(openOrderList));
      print("done dispatching writeAvailableOpenOrderAction(openOrderList)");
      print("state's openOrderList is ${store.state.openOrderList.length} long");
    });
};