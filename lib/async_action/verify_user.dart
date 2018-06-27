import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';

abstract class FirebaseUserAction {
  final FirebaseUser user;
  final Store<AppState> store;

  void run();
}

class VerifyUserAction implements FirebaseUserAction {
  final FirebaseUser user;
  final Store<AppState> store;

  VerifyUserAction(FirebaseUser user, Store store): this.user = user, this.store = store;

  @override
  void run() async {
    Firestore.instance.collection('user').document(user.uid).get()
      .then((document) => document.data, onError: (error) => store.dispatch(new RequestSignUpAction(this.user)))
      .then((data) async {
        if (data['isOrdering']) {
          store.dispatch(new LoginWhileOrderingAction(new User(this.user), 
            await orderReader(data['currentOrder'])));
        } else if (data['isdelivering']) {
            store.dispatch(new LoginWhileDeliveringAction(new User(this.user), 
            await deliveryListReader(data['currentDelivery'])));
        } else {
          store.dispatch(new LoginAction(new User(this.user)));
        }
      });
  }
}