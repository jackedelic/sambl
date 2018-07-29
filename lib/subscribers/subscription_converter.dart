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

Future<CombinedSubscriber> toCurrentDeliverySubscription(DocumentReference delivery, Store<AppState> store) async {
  CombinedSubscriber subscriptions = new CombinedSubscriber();

  subscriptions.add(name: 'pendingDeliverySubscription', subscription: delivery.collection('pending')
    .snapshots().listen((querySnapshot) async {
      store.dispatch(new WriteCurrentDeliveryAction(pending: await deliveryListReader(delivery, DeliveryListType.pending)));
    }));

  subscriptions.add(name: 'approvedDeliverySubscription', subscription: delivery.collection('approved')
    .snapshots().listen((querySnapshot) async {
      store.dispatch(new WriteCurrentDeliveryAction(approved: await deliveryListReader(delivery, DeliveryListType.approved)));
      store.dispatch(new WriteCurrentDeliveryAction(paid: await deliveryListReader(delivery, DeliveryListType.paid)));
    }));
  
  subscriptions.add(name: 'orderDetailSubscription', subscription: await delivery.get().then((snapshot) async {
    final DocumentReference detail = snapshot.data['detail'];
    return detail.snapshots().listen((document) async {
      print("order_detail_sub: " + document.data.toString());
      OrderDetail detail = await orderDetailReader(document.reference);
      store.dispatch(new WriteCurrentDeliveryAction(detail: detail));
      store.dispatch(new SelectHawkerCenterAction(detail.hawkerCenter));
    });
  }));


  subscriptions.add(name: 'delivererChatSubscription', subscription: await delivery.get().then((snapshot) async {
    final DocumentReference detail = snapshot.data['detail'];
    return detail.collection('chat').snapshots().listen((querySnapshot) async {
      print('test');
      Map<String,Conversation> results = {};
      querySnapshot.documents.forEach((thread) {
        List<dynamic> messages = thread.data['messages'];
        Conversation conversation = messages.map((message) {
          if (message['sender'] == "deliverer") {
            return new Message.fromDeliverer(message['message']);
          } else if (message['sender'] == "orderer") {
            return new Message.fromOrderer(message['message']);
          }
        }).fold(Conversation.empty(), (Conversation combined,message) => combined.append(message));
        print("conversation is: " + conversation.toString());
        results.putIfAbsent(thread.documentID, () => conversation);
      });
      store.dispatch(new WriteChatMessagesAction(results));
    });
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

Future<CombinedSubscriber> toCurrentOrderSubscription(DocumentReference order, Store<AppState> store) async {
  CombinedSubscriber subscriptions = new CombinedSubscriber();

  subscriptions.add(name: 'currentOrderSubscription', subscription: order.snapshots().listen((document) async {
      store.dispatch(new WriteCurrentOrderAction(
        Order(await stallListReader(document.data['stalls']), 
          await orderDetailReader(document.data['orderDetail']),
          isPaid: document.data['isPaid'],
          name: document.data['ordererName'],
          isApproved: document.data['isApproved'],
          price: document.data['price'].round())
        ));
  }));
  

  subscriptions.add(name:'ordererChatSubscription', subscription: await order.get().then((order) {
    DocumentReference ref = order.data['orderDetail'].collection('chat').document(order.documentID);
    return ref.snapshots().listen((thread) {
        Map<String,Conversation> results = {};
        List<dynamic> messages = thread.data['messages'];
        Conversation conversation = messages.map((message) {
          if (message['sender'] == "deliverer") {
            return new Message.fromDeliverer(message['message']);
          } else if (message['sender'] == "orderer") {
            return new Message.fromOrderer(message['message']);
          }
        }).fold(Conversation.empty(), (Conversation combined,message) => combined.append(message));
        results.putIfAbsent(thread.documentID, () => conversation);
        store.dispatch(new WriteChatMessagesAction(results));
    });
  }));
  return subscriptions;
}
StreamSubscription<DocumentSnapshot> toUserSubscription(FirebaseUser user, Store<AppState> store) {
  return Firestore.instance.collection('users').document(user.uid).snapshots()
    .listen((snapshot) async {
      if (snapshot.exists) {
        store.dispatch(new LoginAction(new User(user,snapshot.data['balance'])));
        if (snapshot.data['isOrdering']) {
          store.dispatch(new ChangeAppStatusAction(AppStatusFlags.ordering));
          CombinedSubscriber.instance().removeWhere((name,sub) => [
            'availableHawkerCenterSubscription',
            'openOrderListSubscription'].contains(name));
          CombinedSubscriber.instance()
            .addAll(subscriptions: await toCurrentOrderSubscription(snapshot.data['currentOrder'], store));
        } else if (snapshot.data['isDelivering']) {       
          store.dispatch(new ChangeAppStatusAction(AppStatusFlags.delivering));
          CombinedSubscriber.instance().removeWhere((name,sub) => [
            'availableHawkerCenterSubscription',
            'openOrderListSubscription'
            'ordererChatSubscription'].contains(name));
          CombinedSubscriber.instance().addAll(subscriptions: 
            await toCurrentDeliverySubscription(snapshot.data['currentDelivery'], store));
        } else {
          if (store.state.currentAppStatus == AppStatusFlags.delivering) {
            CombinedSubscriber.instance().removeWhere((name,sub) => [
              'pendingDeliverySubscription',
              'approvedDeliverySubscription',
              'orderDetailSubscription',
              'delivererChatSubscription'].contains(name));
          } else if (store.state.currentAppStatus == AppStatusFlags.ordering) {
            CombinedSubscriber.instance().remove(name: 'currentOrderSubscription');
            CombinedSubscriber.instance().remove(name: 'ordererChatSubscription');
          }
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