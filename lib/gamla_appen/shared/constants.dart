
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