import 'package:flutter/material.dart';

class ActiveParking{
  String streetName;
  String startTime;
  String endTime;
  String date;

  ActiveParking({this.streetName, this.endTime, this.startTime, this.date});

  @override
  toString() =>
      'Streetname: $streetName StartTime: ${startTime.toString()} EndTime: ${endTime.toString()}';
}