import 'package:redux/redux.dart';

import 'package:sambl/state/app_state.dart';

abstract class RunnableAction {
  final bool reduceable;

  void run(Store<AppState> store);
}

void runnableActionMiddleware<State>(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is RunnableAction) {
    print(action);  
    action.run(store);
    if (action.reduceable) {
      next(action);
    }
  } else {
    next(action);
  }
}
