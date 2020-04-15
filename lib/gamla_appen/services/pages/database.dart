import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterparkinggit/gamla_appen/models/parking.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference parkCollection = Firestore.instance.collection("parkingPreference");

  //create user data & update user data
  Future updateUserData(String parking, String name, int maxPrice) async {
    return await parkCollection.document(uid).setData({
      'parkering': parking,
      'name': name,
      'maxPrice': maxPrice,

    });
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
      parking: snapshot.data['parking'],
      maxPrice: snapshot.data['maxPrice'],
    );
  }

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