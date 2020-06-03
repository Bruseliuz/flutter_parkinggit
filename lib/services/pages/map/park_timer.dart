import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterparkinggit/models/active_parking.dart';
import 'package:flutterparkinggit/models/paymentModel.dart';
import 'package:flutterparkinggit/services/pages/map/map.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/services/pages/database.dart';

class ParkTimer extends StatefulWidget {
  @override
  _ParkTimerState createState() => _ParkTimerState();
}

class _ParkTimerState extends State<ParkTimer> {

  DateTime date;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  String setParkingText = 'TIME';
  Color startTimerColor = Colors.green[300];
  Color endTimerColor = Colors.red[100];
  bool timerStarted = false;
  String regNumber;
  int price;
  double calculatedPrice;

  String calculatePrice(){
    int hour = picked.hour -  TimeOfDay.now().hour;
    int minute = picked.minute -   TimeOfDay.now().minute;
    int hourInMinute = hour * 60;
    int totalTime = hourInMinute + minute;
    switch(parkingPrice) {
      case '5':
        {price = 5;}
        break;
      case '10':
        {price = 10;}
        break;
      case '15':
        {price = 15;}
        break;
      case '26':
        {price = 26;}
        break;
      case '50':
        {price = 50;}
        break;
    }
    if (parkingPrice.contains('Ingen')) {
      price = 0;
    }
    calculatedPrice = price / 60 * totalTime;
    return '${calculatedPrice.toStringAsFixed(2)} kr';
  }

  List<PaymentModel> paymentList = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(picked == null){
      picked = TimeOfDay.now();
    }
    print(picked);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            regNumber = userData.regNumber;
          }else{
            regNumber = 'ABC123';
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff207FC5),
              elevation: 0.0,
              title: Text('PARK´N STOCKHOLM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),),
            ),
            body: Stack(
                children: <Widget>[
                  Container(
                    color: Color(0xff207FCA),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 30
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(selectedParking.streetName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  RichText(
                                      text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Price per hour: ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400
                                                )
                                            ),
                                            TextSpan(
                                                text: '$parkingPrice kr/tim',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700
                                                )
                                            ),
                                          ]
                                      )
                                  ),
                                  SizedBox(height: 5.0),
                                  Text('${selectedParking.serviceDayInfo}',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                ],
                              ),
                            ],
                          ),
                      SizedBox(height: 20),
                      Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text('$setParkingText',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${picked.format(context)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600
                                ),),
                              FloatingActionButton.extended(
                                onPressed: (){
                                  selectTime(context);
                                },
                                icon: Icon(Icons.watch_later,
                                  color: Color(0xff207FC5),),
                                backgroundColor: Colors.white,
                                label: Text('SET TIMER',
                                  style: TextStyle(
                                      color: Color(0xff207FC5)
                                  ),),
                              )
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text('TOTAL COST',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text('${calculatePrice()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text('PRICE',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text('$parkingPrice kr/tim',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                              children: <Widget>[
                                SizedBox(width: 10),
                                Row(
                                  children: <Widget>[
                                    Text( 'REGISTRATION NUMBER',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                GestureDetector(
                                  onTap:(){
                                    Navigator.pushReplacementNamed(context, '/settings');
                                  } ,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        regNumber == null
                                            ? 'null'
                                            : '${regNumber.toUpperCase()}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Icon(Icons.mode_edit,
                                        color: Colors.white,
                                        size: 25,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                MaterialButton(
                                  key: Key('START PARKING'),
                                  color: startTimerColor,
                                  elevation: 4.0,
                                  onPressed: () async{
                                    setState(() {
                                      if(picked == TimeOfDay.now()){
                                        noTimeSelectedDialog(context);
                                      }else if(calculatedPrice > 0){
                                        startTimerColor = Colors.lightGreen[100];
                                        endTimerColor = Colors.red[300];
                                        timerStarted = true;
                                      }
                                    });
                                  },
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('START PARKING',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: startTimerColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                ),
                                SizedBox(height: 20),
                                MaterialButton(
                                  key: Key('END PARKING'),
                                  color: endTimerColor,
                                  elevation: 4.0,
                                  onPressed: () {
                                    if(timerStarted == true){
                                      endTimerDialog(context);
                                    }else{
                                      Navigator.pop(context);
                                    }
                                  },
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('END PARKING',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Icon(Icons.timer_off, color: Colors.white)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: endTimerColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          );
        }
    );
  }


  Future<void> endTimerDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            elevation: 3.0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.error_outline,
                      color: Color(0xff207FC5)),
                ]),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Are you sure you want to\n       end your parking?',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),),
              ],
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 120),
                    child: MaterialButton(
                      onPressed: () async {
                        await DatabaseService(uid: globalUser.uid).updateUserParkingHistory(
                            selectedParking.streetName,
                            TimeOfDay.now().format(context),
                            _time.format(context),
                            DateTime.now().toIso8601String(),
                            calculatePrice()
                        );
                        Navigator.pushNamedAndRemoveUntil(context, '/wrapper', (_) => false);
                      },
                      color: Colors.white,
                      elevation: 0.0,
                      child: Row(
                        children: <Widget>[
                          Text('YES',
                            style: TextStyle(
                                color: Color(0xff207FC5)
                            ),)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      elevation: 0.0,
                      child: Row(
                        children: <Widget>[
                          Text('NO',
                            style: TextStyle(
                                color: Color(0xff207FC5)
                            ),)
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  getPaymentInformation(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      String cardNumber = doc.data['cardNumber'];
      String cvcCode = doc.data['cvcCode'];
      String monthYear = doc.data['monthYear'];
      String cardHolderName = doc.data['cardHolderName'];
      return PaymentModel(
          cardNumber: cardNumber,
          cvcCode: cvcCode,
          cardHolderName: cardHolderName,
          monthYear: monthYear
      );
    }).toList();
  }


  Future<void>  negativeTimeSelectedDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            elevation: 3.0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.error_outline,
                      color: Color(0xff207FC5)),
                ]),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Please enter the end-time\n       for your parking.',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),),
              ],
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 100, right: 100),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  elevation: 0.0,
                  child: Row(
                    children: <Widget>[
                      Text('OK',
                        style: TextStyle(
                            color: Color(0xff207FC5)
                        ),)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> noTimeSelectedDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            elevation: 3.0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.error_outline,
                      color: Color(0xff207FC5)),
                ]),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Please enter the end-time\n       for your parking.',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),),
              ],
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 100, right: 100),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  elevation: 0.0,
                  child: Row(
                    children: <Widget>[
                      Text('OK',
                        style: TextStyle(
                            color: Color(0xff207FC5)
                        ),)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }


  Future<Null> selectTime(BuildContext context) async {
    _time = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    setState(() {
      picked = _time;
      setParkingText = 'PARKING IS SET FOR';
      calculatePrice();
    });
  }
}