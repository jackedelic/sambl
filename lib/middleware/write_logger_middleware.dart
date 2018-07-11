import 'package:redux/redux.dart';

import 'package:sambl/action/write_action.dart';
import 'package:sambl/state/app_state.dart';

void writeLoggerMiddleware<State>(Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is WriteAction) {
    print(action.runtimeType);
    print(action.toWrite);  
  }
  next(action);
}
