import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';



class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();


}

class _FavoritesState extends State<Favorites> {

  void getData() async {
    Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/ptillaten/within?radius=100&lat=59.32784&lng=18.05306&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    Map data = jsonDecode(response.body);
    print(data);
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('search'),
    );
  }
}
