import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';

/// This action read list of relevant hawker centers from firestore and dispatch an action to write them to the state
final ThunkAction<AppState> getAvailableHawkerCenterAction = (Store<AppState> store) async {
  print('retreiving');
  Firestore.instance.collection('hawker_centers').getDocuments()
    .then((collection){
      print('test');
      print(collection);
      return collection.documents.where((document) => true);
    })
    .then((documents) async => await Stream.fromIterable(documents).asyncMap<HawkerCenter>(
      (hawkerCenter) async => await hawkerCenterReader(hawkerCenter.reference)).toList())
    .then((hawkerCenterList) {
      print(hawkerCenterList);
      store.dispatch(new WriteAvailableHawkerCenterAction(hawkerCenterList));
    })
    .catchError((error) => print(error));
};