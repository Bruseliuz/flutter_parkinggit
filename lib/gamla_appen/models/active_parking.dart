import 'package:flutter/material.dart';

class ActiveParking{
  String streetName;
  String startTime;
  String endTime;

  ActiveParking({this.streetName, this.endTime, this.startTime});

  @override
  toString() =>
      'Streetname: $streetName StartTime: ${startTime.toString()} EndTime: ${endTime.toString()}';
}