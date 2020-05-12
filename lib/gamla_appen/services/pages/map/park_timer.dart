import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';


class ParkTimer extends StatefulWidget {
  @override
  _ParkTimerState createState() => _ParkTimerState();
}

class _ParkTimerState extends State<ParkTimer> {

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  String setParkingText = 'Parking is set for:';

  @override
  Widget build(BuildContext context) {
    if(picked == null){
      picked = TimeOfDay.now();
      setParkingText = 'The time is:';
    }
    return Scaffold(
      appBar: AppBar(
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff4896cf),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Engatavägen 99',
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400
                                      )
                                    ),
                                    TextSpan(
                                        text: '26kr/h',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700
                                        )
                                    ),
                                  ]
                                )
                              ),
                              SizedBox(height: 5.0),
                              RichText(
                                  text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Service info: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400
                                            )
                                        ),
                                        TextSpan(
                                            text: 'Onsdagar 06 - 12',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                      ]
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text('$setParkingText',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(height: 10.0),
                      Text('${picked.format(context)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: 250),
                      MaterialButton(
                        key: Key('START PARKING'),
                        color: Colors.green[300],
                        elevation: 4.0,
                        onPressed: (){
                          selectTime(context);
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
                            Icon(Icons.timer_off, color: Colors.white)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.green[300],
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        key: Key('END PARKING'),
                        color: Colors.red[300],
                        elevation: 4.0,
                        onPressed: (){
                          Navigator.pop(context);
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
                                color: Colors.red[300],
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
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
      setParkingText = 'Parking is set for:';
    });
  }
}