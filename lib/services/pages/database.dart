import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterparkinggit/models/parking.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/models/paymentModel.dart';
import 'package:flutterparkinggit/services/pages/map/parking_area.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference parkCollection = Firestore.instance.collection("parkingPreference");

  Future updateUserData(String parking, String name, int maxPrice, int radius, String regNumber) async {
    return await parkCollection.document(uid).setData({
      'parkering': parking,
      'name': name,
      'maxPrice': maxPrice,
      'radius': radius,
      'regNumber': regNumber
    });
  }

  Future updateUserFavorites(String price, String latLong, String address,
      String serviceInfo, bool favorite,String numberOfParkingSpots, String availableSpots) async {
    return await parkCollection.document(uid).collection('favoriteParkings').document(address).setData({
      'price': price,
      'streetName': address,
      'coordinates': latLong,
      'serviceDayInfo': serviceInfo,
      'favorite': favorite,
      'numberOfParkingSpots': numberOfParkingSpots,
      'availableParkingSpots': availableSpots
    });
  }

  Future updateUserPaymentCard(String cardNumber, String monthYear,
      String cvcCode, String cardHolderName) async {
    return await parkCollection
        .document(uid)
        .collection('paymentinfo')
        .document(cardNumber)
        .setData({
      'cardNumber': cardNumber,
      'monthYear': monthYear,
      'cvcCode': cvcCode,
      'cardHolderName': cardHolderName
    });
  }

  Future updateUserParkingHistory(String streetName, String startTime, String endTime, String date, String totalPrice) async {
    return await parkCollection.document(uid).collection('parkinghistory').document(streetName).setData({
      'streetName':streetName,
      'startTime':startTime,
      'endTime':endTime,
      'date': date,
      'totalPrice': totalPrice
    });
  }

  Future clearUserParkingHistory()async {
    return await parkCollection.document(uid).collection('parkinghistory').getDocuments().then((snapshot) {
    for(DocumentSnapshot ds in snapshot.documents) {
      ds.reference.delete();
    }});
  }

  String getCardNumber() {
    try {
      DocumentReference docRef = parkCollection.document(uid).collection(
          'paymentinfo').document('card information');
      docRef.get().then((snapshot) {
        return snapshot['cardNumber'];
      });
    } catch (e) {
      return 'No cardNumber';
    }
  }

  String getUsername() {
    try {
      DocumentReference docRef = parkCollection.document(uid);
      docRef.get().then((snapshot) {
        return snapshot['name'];
      });
    } catch (e) {
      return 'No Name';
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
      radius: snapshot.data['radius'],
      regNumber: snapshot.data['regNumber']
    );
  }

  PaymentModel _paymentDataFromSnapshot(DocumentSnapshot snapshot) {
    return PaymentModel(
        cardHolderName: snapshot.data['cardHolderName'],
        cardNumber: snapshot.data['cardNumber'],
        cvcCode: snapshot.data['cvcCode'],
        monthYear: snapshot.data['monthYear']
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

  Stream<PaymentModel> get paymentInfo {
    return parkCollection.document(uid).collection('paymentinfo').document(
        'card information').snapshots()
        .map(_paymentDataFromSnapshot);
  }
}