import 'package:redux/redux.dart';

import 'package:sambl/async_action/verify_user.dart';

void firebaseAuthMiddleware<State>(Store<State> store, dynamic action, NextDispatcher next) {
  if (action is FirebaseUserAction) {
    action.run();
  } else {
    next(action);
  }
}