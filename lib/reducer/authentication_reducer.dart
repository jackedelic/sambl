import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';


final Reducer<AppState> authenticationReducer = combineReducers([
  TypedReducer<AppState,LoginAction> (loginReducer),
  TypedReducer<AppState,RequestSignUpAction>((state,action) {
    return new AppState.awaitingSignUp();
  }),
  TypedReducer<AppState,LogoutAction> ((state,action) {
    return new AppState.unauthenticated();
  })
]);

final Reducer<AppState> loginReducer = combineReducers([
  TypedReducer<AppState,LoginAction>((state,action) => 
      new AppState.authenticated(action.user)),
  TypedReducer<AppState,LoginWhileOrderingAction>((state,action) => 
      new AppState.ordering(action.user, action.order)),
  TypedReducer<AppState,LoginWhileDeliveringAction>((state,action) => 
      new AppState.delivering(action.user, action.deliveryList))
]);