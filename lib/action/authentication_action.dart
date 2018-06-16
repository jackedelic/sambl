import 'package:firebase_auth/firebase_auth.dart';
import 'package:sambl/state/app_state.dart';

class AuthenticationAction {

}

class LogoutAction extends AuthenticationAction {

}

class SignUpAction extends AuthenticationAction {

}

class AuthenticateWithGoogleAction extends AuthenticationAction {
  
}

class LoginAction extends AuthenticationAction {
  final FirebaseUser user;

  LoginAction(this.user);

  bool isSuccessful() {
    return user != null;
  }
}

class LoginWhileOrderingAction extends LoginAction {
  final Order order;

  LoginWhileOrderingAction(FirebaseUser usr, Order order) : this.order = order, super(usr);

}