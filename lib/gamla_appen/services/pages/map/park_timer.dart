import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';


class ParkTimer extends StatefulWidget {
  @override
  _ParkTimerState createState() => _ParkTimerState();
}

class _ParkTimerState extends State<ParkTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xff207FC5),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
              vertical: 70,
              horizontal: 40
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'PARK´N',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'STARTED',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Text('INFORMATION OM EN PARKERING'),
                  SizedBox(height: 100.0),
                  MaterialButton(
                    key: Key('SignIn'),
                    color: Colors.redAccent[700],
                    elevation: 4.0,
                    onPressed: (){

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
                            color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}