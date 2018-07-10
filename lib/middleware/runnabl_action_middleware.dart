import 'package:redux/redux.dart';

import 'package:sambl/state/app_state.dart';

abstract class RunnableAction {
  void run(Store<AppState> store);
}

void runnableActionMiddleware<State>(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is RunnableAction) {
    print(action);  
    action.run(store);
  } else {
    next(action);
  }
}
