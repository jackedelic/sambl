import 'package:redux/redux.dart';

import 'package:sambl/async_action/verify_user.dart';

void thunkMiddleware<State>(Store<State> store, dynamic action, NextDispatcher next) {
  if (action is VerifyUserAction) {
    action.run();
  } else {
    next(action);
  }
}