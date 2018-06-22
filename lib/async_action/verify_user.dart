import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';

class VerifyUserAction {
  final FirebaseUser user;
  final Store<AppState> store;

  VerifyUserAction(FirebaseUser user, Store store): this.user = user, this.store = store;

  void run() async {
    print('verifying user');
    Firestore.instance.collection('user').document(user.uid).get()
      .then((document) => document.data, onError: (error) => store.dispatch(new RequestSignUpAction()))
      .then((data){
        if (data['isOrdering']) {
          //store.dispatch(new LoginWhileOrderingAction(new User(this.user), new Order.fromFirebase(data['currentOrder'])));
        } else if (data['isdelivering']) {
         // store.dispatch(new LoginWhileDeliveringAction(new User(this.user), new DeliveryList.fromFirebase()));
        } else {
          store.dispatch(new LoginAction(new User(this.user)));
        }
      });
  }
}