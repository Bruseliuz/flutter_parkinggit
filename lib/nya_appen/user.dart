class User {

  String _name;
  String _email;
  bool _accessibility;

  User(this._name, this._email, this._accessibility);

  @override
  String toString() {
    return 'Current user: $_name';
  }

}