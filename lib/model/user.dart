import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/core.dart';

/// Encapsulates all necessary information about a user of the application.
class User {
  final Optional<FirebaseUser> onlineUser;
  final int balance;

  User(FirebaseUser user, int balance): this.onlineUser = Optional.of(user), this.balance = balance;

  String get name {
    return onlineUser.transform((user) => user.displayName).or("");
  }

  String get photoUrl {

    return onlineUser.transform((user) => user.photoUrl).or('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png');
  }

  User.initial(): this.onlineUser = Optional<FirebaseUser>.absent(), this.balance = 0;

  String get uid {
    return onlineUser.transform((user) => user.uid).orNull;
  }

}