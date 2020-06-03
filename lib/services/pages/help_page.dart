import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<bool> _selections = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff207FC5),
        centerTitle: true,
        title: Text('HELP',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 17
        ),),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('What do the colors of the markers mean?',
                style: TextStyle(
                    color: Color(0xff207FC5),
                    fontWeight: FontWeight.w600,
                    fontSize: 15
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8,bottom: 8),
                child: Text('The different colors indicates the price of the parking area.',
                  style: TextStyle(
                      color: Color(0xff207FC5),
                      fontWeight: FontWeight.w300,
                      fontSize: 13
                  ),),
              ),
              Container(
                padding: EdgeInsets.only(top: 8,bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset('assets/locmarker775.png',scale: 15),
                        Padding(
                          padding: EdgeInsets.only(top:8.0),
                          child: Text('5 - 10kr/h',
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset('assets/locmarker776.png',scale: 15),
                        Padding(
                          padding: EdgeInsets.only(top:8.0),
                          child: Text('15 - 26kr/h',
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset('assets/locmarker778.png',scale: 15),
                        Padding(
                          padding: EdgeInsets.only(top:8.0),
                          child: Text('50kr/h',
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text('How do I select which parking areas to show?',
                style: TextStyle(
                    color: Color(0xff207FC5),
                    fontWeight: FontWeight.w600,
                    fontSize: 15
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8,bottom: 8),
                child: Text('Under "Filter" you can set your personal preferences.',
                  style: TextStyle(
                      color: Color(0xff207FC5),
                      fontWeight: FontWeight.w300,
                      fontSize: 13
                  ),
                ),
              ),
              Text('You can filter by type of parking.',
                style: TextStyle(
                    color: Color(0xff207FC5),
                    fontWeight: FontWeight.w400,
                    fontSize: 13
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(top: 8,bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ToggleButtons(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 33, right: 33),
                                  child: Icon(Icons.motorcycle,
                                    color: Color(0xff207FC5),)),
                              Container(
                                  padding: EdgeInsets.only(left: 33, right: 33),
                                  child: Icon(Icons.accessible,
                                    color: Color(0xff207FC5),)),
                              Container(
                                  padding: EdgeInsets.only(left: 33, right: 33),
                                  child: Icon(Icons.directions_car,
                                  color: Color(0xff207FC5),)),
                            ],
                            isSelected: _selections,
                            disabledBorderColor:Color(0xff207FC5),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 35, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('MC',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          Text(
                            'Disabled parking',
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          Text('CAR',
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('Or choose how far from the location\nyou want to see parking areas.',
                style: TextStyle(
                    color: Color(0xff207FC5),
                    fontWeight: FontWeight.w400,
                    fontSize: 13
                ),
              ),
              SizedBox(height: 5),
              Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12,
            ),
            child: Column(
              children: <Widget>[
                Text('300 m',
                  style: TextStyle(
                      color:  Color(0xff207FC5),
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ),),
                Slider(
                  activeColor: Color(0xff207FC5),
                  inactiveColor: Colors.black12,
                  value: 300,
                  min: 100,
                  max: 500,
                  divisions: 4,
                  onChanged: (val)=>setState(() {
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('100',
                      style: TextStyle(
                          color:  Color(0xff207FC5),
                          fontSize: 14,
                          fontWeight: FontWeight.w300
                      ),),
                    Text('500',
                      style: TextStyle(
                          color:  Color(0xff207FC5),
                          fontSize: 14,
                          fontWeight: FontWeight.w300
                      ),),
                  ],
                ),
              ],
            )
          ),
            ],
          ),
        ),
      ),
    );
  }
}
