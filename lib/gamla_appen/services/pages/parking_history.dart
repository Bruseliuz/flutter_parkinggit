import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/active_parking.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:provider/provider.dart';

class ParkingHistory extends StatefulWidget {
  @override
  _ParkingHistoryState createState() => _ParkingHistoryState();
}

User globalUser;

class _ParkingHistoryState extends State<ParkingHistory> {

  List<ActiveParking> tempList = [];

  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<User>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('parkingPreference').document(globalUser.uid).collection('parkinghistory').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        tempList = getParkingHistory(snapshot);
        print(tempList);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff207FC5),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('PARKING HISTORY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.history,
                color: Colors.white,
                size: 20,)
              ],
            ),
          ),
          body: tempList.isEmpty ? _emptyList(context) :
          ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(
                  color: Colors.white,
                ),
            padding: const EdgeInsets.all(8),
            itemCount: tempList.length,
            itemBuilder: _getParkingHistoryList,
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async{
                setState(() async {
                  await DatabaseService(uid: globalUser.uid).clearUserParkingHistory();
                });
              },
              backgroundColor: Color(0xff207FC5),
              icon: Icon(Icons.delete_forever,
              color: Colors.white70,),
              label: Text('CLEAR HISTORY',
              style: TextStyle(
                color: Colors.white
              ),)),
        );
      }
    );
  }

  Widget _getParkingHistoryList(BuildContext context, int index){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:  Color(0xff207FC5),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0,2)
            )
          ],
        ),
        child: ListTile(
          title: Column(
            children: <Widget>[
              Text('${tempList[index].streetName}',
            style: TextStyle(
                color: Colors.white,
              fontWeight: FontWeight.w600,
            ),),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Time: ${tempList[index].startTime} - ${tempList[index].endTime}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                  ),),
                  Text('Date: ${tempList[index].date}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                    ),),
                ],
              ),
            ],
        ),
      ),
    ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('NO PARKING HISTORY',
                  style: TextStyle(
                    color: Color(0xff207FC5),
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  )),
            ],
          )
        ],
      ),
    );
  }

  getParkingHistory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      String streetName = doc.data['streetName'];
      String startTime = doc.data['startTime'];
      String endTime = doc.data['endTime'];
      String date = doc.data['date'];
      List<String> temp = date.split('T');
      String dateOnly = temp[0];
      return ActiveParking(
          streetName: streetName,
        startTime: startTime,
        endTime: endTime,
        date: dateOnly
      );
    }).toList();
  }
}
