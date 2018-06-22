import 'package:firebase_auth/firebase_auth.dart';
import 'package:sambl/state/app_state.dart';

class AuthenticationAction {

}

class LogoutAction extends AuthenticationAction {

}

class RequestSignUpAction {
  
}

class LoginAction extends AuthenticationAction {
  final User user;

  LoginAction(this.user);

  bool isSuccessful() {
    return user != null;
  }
}

class LoginWhileOrderingAction extends LoginAction {
  final Order order;

  LoginWhileOrderingAction(User user, Order order) : this.order = order, super(user);

}

class LoginWhileDeliveringAction extends LoginAction {
  final DeliveryList deliveryList;

  LoginWhileDeliveringAction(User user, DeliveryList deliveryList) : this.deliveryList = deliveryList, super(user);
}