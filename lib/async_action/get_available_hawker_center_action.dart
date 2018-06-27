import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';

final ThunkAction<AppState> getAvailableHawkerCenterAction = (Store<AppState> store) async {

  Firestore.instance.collection('hawkerCenters').getDocuments()
    .then((collection) => collection.documents.where((document) => true))
    .then((documents) => Stream.fromIterable(documents).asyncMap<HawkerCenter>(
      (hawkerCenter) async => await hawkerCenterReader(hawkerCenter.reference)).toList())
    .then((hawkerCenterList) => store.dispatch(
      new WriteAvailableHawkerCenterAction(hawkerCenterList)));
};