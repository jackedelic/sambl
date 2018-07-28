import 'package:redux/redux.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';


final Reducer<AppState> authenticationReducer = combineReducers([
  TypedReducer<AppState,LoginAction> (loginReducer),
  TypedReducer<AppState,RequestSignUpAction>((state,action) {
    return state.copyWith(currentAppStatus: AppStatusFlags.awaitingSignup);
  }),
  TypedReducer<AppState,LogoutAction> ((state,action) {
    return new AppState.initial();
  })
]);

final Reducer<AppState> loginReducer = combineReducers([
  TypedReducer<AppState,LoginAction>((state,action) => 
      new AppState.initial().copyWith(currentAppStatus: AppStatusFlags.authenticated, currentUser: action.user)),
]);