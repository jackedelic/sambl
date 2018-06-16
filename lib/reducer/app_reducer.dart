import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  print(action);
  return AppState.initial();
}