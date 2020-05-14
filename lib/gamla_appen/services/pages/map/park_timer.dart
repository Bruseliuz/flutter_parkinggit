import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';


class ParkTimer extends StatefulWidget {
  @override
  _ParkTimerState createState() => _ParkTimerState();
}

class _ParkTimerState extends State<ParkTimer> {

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  String setParkingText = '';
  Color startTimerColor = Colors.green[300];
  Color endTimerColor = Colors.red[100];
  bool timerStarted = false;

  @override
  Widget build(BuildContext context) {
    if(picked == null){
      picked = TimeOfDay.now();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff207FC5),
        leading: Icon(Icons.local_parking,
          color: Colors.white,),
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
                    SizedBox(height: 40),
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
                    Container( //TODO - Dela upp i två text fields
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                      child: Column(
                        children: <Widget>[
                             SizedBox(width: 10),
                             Text( 'REGISTRATION NUMBER',
                               style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 12,
                               ),
                             ),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              Container(
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    decoration: InputDecoration(
                                        hintText: 'ABC',
                                        hintStyle: TextStyle(
                                          color: Color(0xff207FC5)
                                        ),
                                        border: InputBorder.none
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0,2)
                                      )
                                    ]
                                ),
                                padding: EdgeInsets.only(left: 18.5),
                              ),
                              SizedBox(width: 0.5),
                              Container(
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    decoration: InputDecoration(
                                        hintText: '123',
                                        hintStyle: TextStyle(
                                            color: Color(0xff207FC5)
                                        ),
                                        border: InputBorder.none
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(3,2)
                                      )
                                    ]
                                ),
                                padding: EdgeInsets.only(left: 18.5),
                              ),
                              SizedBox(width: 5),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          SizedBox(height: 30),
                          MaterialButton(
                            key: Key('START PARKING'),
                            color: startTimerColor,
                            elevation: 4.0,
                            onPressed: () {
                              setState(() {
                                if(picked == TimeOfDay.now()){
                                  noTimeSelectedDialog(context);
                                }else{
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
    });
  }
}