import 'dart:async';

import 'package:meta/meta.dart';

class CombinedSubscriber {
  Map<String,StreamSubscription> _subscriptions;

  static CombinedSubscriber _instance = new CombinedSubscriber(); 

  factory CombinedSubscriber.instance() {
    return _instance;
  }

  CombinedSubscriber(): this._subscriptions = new Map<String,StreamSubscription>();

  Future<void> remove({@required String name}) async {
    return await _subscriptions[name].cancel().then((_) {
      _subscriptions.remove(name);
      print('current list of subscriptions' + _subscriptions.keys.toString());
    });
  }

  Future<void> removeAll() async {
    return Stream.fromIterable(_subscriptions.values).asyncMap((sub) async => await sub.cancel())
      .toList().then((_) {
        _subscriptions = {};
        return;
      });
  }

  void add({@required String name, @required StreamSubscription subscription}) {
    // assert(!_subscriptions.containsKey(name));
    _subscriptions.putIfAbsent(name, () => subscription);
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  void addAll({@required CombinedSubscriber subscriptions}) {
    _subscriptions.addEntries(subscriptions.toList());
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  void removeWhere(bool test(String name, StreamSubscription sub)) {
    _subscriptions.removeWhere(test);
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  StreamSubscription get({@required String name}) {
    return _subscriptions[name];
  }

  bool contains({@required String name}) {
    return _subscriptions.containsKey(name);
  }

  List<MapEntry<String,StreamSubscription>> toList() {
    return this._subscriptions.entries.toList();
  }

  
}