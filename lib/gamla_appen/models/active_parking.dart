import 'package:flutter/material.dart';

class ActiveParking{
  String streetName;
  String startTime;
  String endTime;
  String date;
  String totalPrice;

  ActiveParking({this.streetName, this.endTime, this.startTime, this.date, this.totalPrice});

  @override
  toString() =>
      'Streetname: $streetName StartTime: ${startTime.toString()} EndTime: ${endTime.toString()}';
}