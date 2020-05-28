import 'package:flutter/material.dart';

class PaymentModel {
  String cardHolderName;
  String cardNumber;
  String cvcCode;
  String monthYear;

  PaymentModel(
      {this.cardHolderName, this.cardNumber, this.cvcCode, this.monthYear});
}
