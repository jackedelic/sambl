/// Encapsulates all necessary information about a user of the application.
class User {

  String _name;
  String _uid;
  String _email;
  
  /// default constructior for the AppUser class, resets all flags to false 
  /// and all else to 'null'
  User(this._name,this._email,this._uid);

  factory User.initial() => User(null,null,null);

}