
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
      borderSide: BorderSide(color: Colors.lightBlue, width: 2.2),
    )
);

final parkBoxDecoration = BoxDecoration(
    color: Color(0xff1E74B4),
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
          color: Colors.black12,
          blurRadius: 5.0,
          offset: Offset(0,2)
      )
    ]
);

final settingsDecoration = BoxDecoration(
    color: Colors.white70,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
          color: Colors.black12,
          blurRadius: 5.0,
          offset: Offset(0,2)
      )
    ]
);

