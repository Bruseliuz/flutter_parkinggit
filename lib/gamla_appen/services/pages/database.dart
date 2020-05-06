import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterparkinggit/gamla_appen/models/parking.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/parking_area.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference parkCollection = Firestore.instance.collection("parkingPreference");
  final CollectionReference favoriteCollection = Firestore.instance.collection('favoriteParkings');

  //create user data & update user data
  Future updateUserData(String parking, String name, int maxPrice, int radius) async {
    return await parkCollection.document(uid).setData({
      'parkering': parking,
      'name': name,
      'maxPrice': maxPrice,
      'radius': radius,
    });
  }

  Future updateUserFavorites(String latLong, String address, String serviceInfo, bool favorite, String availableSpots) async {
    return await parkCollection.document(uid).collection('favoriteParkings').document(address).setData({
      'streetName': address,
      'coordinates': latLong,
      'serviceDayInfo': serviceInfo,
      'favorite': favorite,
      'availableParkingSpots': availableSpots
    });
  }

  Future<int> getUsername(String username) async {
    try {
      DocumentReference docRef = parkCollection.document(uid);
      if (docRef != null) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future updateParkingPref(String parking) async {
    return await parkCollection.document(uid).setData({
      'parkering': parking
    });
  }

  //parking from a snapshop
  List<Parking> _parkingListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Parking(
        name: doc.data['name'] ?? '',
        parkering: doc.data['parkering'] ?? '',
        maxPrice: doc.data['maxPrice'] ?? 0,
      );
    }).toList();
  }

  //userData form snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      parking: snapshot.data['parkering'],
      maxPrice: snapshot.data['maxPrice'],
      radius: snapshot.data['radius']
    );
  }

  List<ParkingArea> _favoriteListFromSnapshot(QuerySnapshot snapshot) {
    print(parkCollection.document(uid).collection('favoriteParkings').snapshots().toString());
    return snapshot.documents.map((doc) {
      return ParkingArea(
        streetName: doc.data['streetName'],
        coordinates: doc.data['coordinates'],
        favorite: doc.data['favorite'],
        serviceDayInfo: doc.data['serviceDayInfo'],
        availableParkingSpots: doc.data['availableParkingSpots']
      );
    }).toList();
  }

//  Stream<List<ParkingArea>> get parkingArea{
//    return parkCollection.document(uid).collection('favoriteParkings').getDocuments()
//        .map(_favoriteListFromSnapshot);
//  }

  //get parkingPreference stream
  Stream<List<Parking>> get parking{
    return parkCollection.snapshots()
    .map(_parkingListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return parkCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
}