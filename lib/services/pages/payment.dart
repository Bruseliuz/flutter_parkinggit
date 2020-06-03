import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/paymentModel.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:provider/provider.dart';

import 'map/map.dart';

class PaymentList extends StatefulWidget {
  @override
  _PaymentListState createState() => _PaymentListState();
}

User globalUser;

class _PaymentListState extends State<PaymentList> {
  List<PaymentModel> paymentList = [];

  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<User>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('parkingPreference')
            .document(globalUser.uid)
            .collection('paymentinfo')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) paymentList = getPaymentInformation(snapshot);
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Color(0xff207FC5),
              title: Text(
                'PAYMENT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
            ),
            body: paymentList.isEmpty
                ? _emptyPaymentList(context)
                : ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: paymentList.length,
                    itemBuilder: _getPaymentInfoList,
                  ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Color(0xff4896cf),
              label: Row(
                children: <Widget>[
                  Text(
                    'ADD CARD',
                  ),
                  Icon(
                    Icons.add,
                    size: 20,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/addPayment');
              },
            ),
          );
        });
  }

  Widget _getPaymentInfoList(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff207FC5),
                Color(0xff348aca),
                Color(0xff4896cf),
                Color(0xff4896cf)
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 5.0,
                offset: Offset(0, 2),
              )
            ]),
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xff4896cf),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.credit_card,
                            color: Colors.white,
                            size: 35,
                          ),
                          Text(
                            '  **** **** **** ${paymentList[index].cardNumber.substring(12, (16))}',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Valid through: ${paymentList[index].monthYear.substring(0, (2))} / ${paymentList[index].monthYear.substring(2, (4))}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Card holder: ${paymentList[index].cardHolderName}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        parkCollection
                            .document(globalUser.uid)
                            .collection('paymentinfo')
                            .document(
                                paymentList[index].cardNumber) //streetName
                            .delete();
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyPaymentList(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('NO PAYMENT REGISTERED',
                  style: TextStyle(
                      color: Color(0xff207FC5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  getPaymentInformation(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      String cardNumber = doc.data['cardNumber'];
      String cvcCode = doc.data['cvcCode'];
      String monthYear = doc.data['monthYear'];
      String cardHolderName = doc.data['cardHolderName'];
      return PaymentModel(
          cardNumber: cardNumber,
          cvcCode: cvcCode,
          cardHolderName: cardHolderName,
          monthYear: monthYear);
    }).toList();
  }
}
