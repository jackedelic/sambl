import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/async_action/google_sign_in.dart';
import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';


  final authenticateWithGoogle = (Store<AppState> store) async {
    try {
      LoginAction login = new LoginAction(await _handleGoogleSignIn());
      if (!login.isSuccessful()) {
        throw new Exception('Login Failed');
      } else {
        store.dispatch(LoginAction);
      }
    } catch (error) {
      print(error);
    }
  };

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }

  // Future<void> _handleGoogleSignOut() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  // }