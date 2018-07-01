import 'package:redux/redux.dart';

import 'package:sambl/state/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/async_action/verify_user.dart';
import 'package:sambl/async_action/firestore_write_action.dart';

void firebaseMiddleware<State>(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is FirebaseUserAction || action is FirestoreWriteAction) {
    print(action);  
    action.run(store);
  } else {
    next(action);
  }
}
