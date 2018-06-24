import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';

  final ThunkAction<AppState> signOutAction = (Store<AppState> store) async {
    await FirebaseAuth.instance.signOut()
      .then((_) {
        print('signing out');
        store.dispatch(new LogoutAction());
      });
  };