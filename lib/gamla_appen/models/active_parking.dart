import 'package:flutter/material.dart';

class ActiveParking{
  String streetName;
  TimeOfDay startTime;
  TimeOfDay endTime;

  ActiveParking({this.streetName, this.endTime, this.startTime});

  @override
  toString() =>
      'Streetname: $streetName StartTime: ${startTime.toString()} EndTime: ${endTime.toString()}';
}