import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/subscribers/combined_subscriber.dart';
import 'package:sambl/utility/firebase_reader.dart';
import 'package:sambl/utility/sort_hawker_center.dart';

CombinedSubscriber toCurrentDeliverySubscription(DocumentReference delivery, Store<AppState> store) {
  CombinedSubscriber subscriptions = new CombinedSubscriber();

  subscriptions.add(name: 'pendingDeliverySubscription', subscription: delivery.collection('pending')
    .snapshots().listen((querySnapshot) async {
      store.dispatch(new WriteCurrentDeliveryAction(store.state.currentDeliveryList
        .copyWith(pending: await deliveryListReader(delivery, DeliveryListType.pending))));
    }));

  subscriptions.add(name: 'approvedDeliverySubscription', subscription: delivery.collection('approved')
    .snapshots().listen((querySnapshot) async {
      store.dispatch(new WriteCurrentDeliveryAction(store.state.currentDeliveryList
        .copyWith(pending: await deliveryListReader(delivery, DeliveryListType.approved))));
    }));
  
  subscriptions.add(name: 'orderDetailSubscription', subscription:  delivery.snapshots()
    .listen((document) async {
      store.dispatch(new WriteCurrentDeliveryAction(store.state.currentDeliveryList
        .copyWith(detail: await orderDetailReader(document.data['detail']))));
    }));

  return subscriptions;
}

StreamSubscription toAvailableHawkerCenterSubscription(Store<AppState> store) {
  return Firestore.instance.collection('hawker_centers').snapshots()
    .listen((querySnapshot) async {
      store.dispatch(new WriteAvailableHawkerCenterAction(await sortHawkerCenter( 
        await Stream.fromIterable(querySnapshot.documents
          .where((document) => true))
          .asyncMap<HawkerCenter>((hawkerCenter) async => await hawkerCenterReader(hawkerCenter.reference))
          .toList()
      )));
    });
}

StreamSubscription toOpenOrderListSubscription(DocumentReference hawkerCenter, Store<AppState> store) {
  return hawkerCenter.collection('open_orders').snapshots().listen((snapshot) async {
    store.dispatch(new WriteAvailableOpenOrderAction(
      await Stream.fromIterable(snapshot.documents.map<String>((document) => document.documentID))
      .asyncMap<OrderDetail>((openOrderID) async => 
        await orderDetailReader(Firestore.instance.collection('open_orders').document(openOrderID)))
      .toList())); 
  });
}

StreamSubscription toCurrentOrderSubscription(DocumentReference order, Store<AppState> store) {
  return order.snapshots().listen((document) async {
      store.dispatch(new WriteCurrentOrderAction(
        Order(await stallListReader(document.data['stalls']), 
          await orderDetailReader(document.data['orderDetail']))
        ));
  });
}

StreamSubscription<DocumentSnapshot> toUserSubscription(FirebaseUser user, Store<AppState> store) {
  return Firestore.instance.collection('users').document(user.uid).snapshots()
    .listen((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data['isOrdering']) {
          store.dispatch(new ChangeAppStatusAction(AppStatusFlags.ordering));
          CombinedSubscriber.instance().removeWhere((name,sub) => [
            'availableHawkerCenterSubscription',
            'openOrderListSubscription'].contains(name));
          CombinedSubscriber.instance().add(name: 'currentOrderSubscription',
            subscription: toCurrentOrderSubscription(snapshot.data['currentOrder'], store));
        } else if (snapshot.data['isDelivering']) {       
          store.dispatch(new ChangeAppStatusAction(AppStatusFlags.delivering));
          CombinedSubscriber.instance().removeWhere((name,sub) => [
            'availableHawkerCenterSubscription',
            'openOrderListSubscription'].contains(name));
          CombinedSubscriber.instance().addAll(subscriptions: 
            toCurrentDeliverySubscription(snapshot.data['currentDelivery'], store));
        } else {
          if (store.state.currentAppStatus == AppStatusFlags.delivering) {
            CombinedSubscriber.instance().removeWhere((name,sub) => [
              'pendingDeliverySubscription',
              'approvedDeliverySubscription',
              'orderDetailSubscription'].contains(name));
          } else if (store.state.currentAppStatus == AppStatusFlags.ordering) {
            CombinedSubscriber.instance().remove(name: 'currentOrderSubscription');
          }
          store.dispatch(new LoginAction(new User(user)));
          CombinedSubscriber.instance().add(
            name: 'availableHawkerCenterSubscription',
            subscription: toAvailableHawkerCenterSubscription(store),
          );
        }
      } else {
        store.dispatch(new RequestSignUpAction(user));
      }
    });
}