class User {

  final String uid;

  User({this.uid});

}

class UserData{

  final String uid;
  final String name;
  final String parking;
  final int maxPrice;
  final int radius;
  final List favoritesList;

  UserData({this.uid, this.name, this.parking, this.maxPrice, this.radius, this.favoritesList});

}