import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/authentication_action.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sambl/utility/firebase_reader.dart';

StreamSubscription<DocumentSnapshot> toUserSubscription(FirebaseUser user, Store<AppState> store) {
  return Firestore.instance.collection('users').document(user.uid).snapshots()
    .listen((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data['isOrdering']) {
          store.dispatch(new LoginWhileOrderingAction(new User(user), 
            await orderReader(snapshot.data['currentOrder'])));
        } else if (snapshot.data['isDelivering']) {
          store.dispatch(new LoginWhileDeliveringAction(new User(user), new CombinedDeliveryList(                
                pending: await deliveryListReader(snapshot.data['currentDelivery'],DeliveryListType.pending),
                approved: await deliveryListReader(snapshot.data['currentDelivery'],DeliveryListType.approved),
                detail: await snapshot.data['currentDelivery'].get().then((delivery) => 
                  orderDetailReader(delivery.data['detail'])))
              ));
        } else {
          store.dispatch(new LoginAction(new User(user)));
        }
      } else {
        store.dispatch(new RequestSignUpAction(user));
      }
    });
}