import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


class LocationLoader extends StatefulWidget {
  @override
  _LocationLoaderState createState() => _LocationLoaderState();
}

class _LocationLoaderState extends State<LocationLoader> {
/*
  void getData() async {
  Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/servicedagar/weekday/måndag?outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
  Map data = jsonDecode(response.body);
  print(data);


  }*/

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
