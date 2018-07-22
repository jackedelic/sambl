import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/core.dart';

/// Encapsulates all necessary information about a user of the application.
class User {
  final Optional<FirebaseUser> onlineUser;
  final int balance;

  User(FirebaseUser user, int balance): this.onlineUser = Optional.of(user), this.balance = balance;

  User.initial(): this.onlineUser = Optional<FirebaseUser>.absent(), this.balance = 0;
}