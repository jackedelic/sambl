import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/core.dart';

/// Encapsulates all necessary information about a user of the application.
class User {
  Optional<FirebaseUser> onlineUser;

  User(FirebaseUser user): this.onlineUser = Optional.of(user);

  User.initial(): this.onlineUser = Optional<FirebaseUser>.absent();
}