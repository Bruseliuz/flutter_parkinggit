import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/paymentModel.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';

import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/favorites.dart';
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
      stream: Firestore.instance.collection('parkingPreference').document(globalUser.uid).collection('paymentinfo').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData)
          paymentList = getPaymentInformation(snapshot);
        return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xff207FC5),
                  title: Text('PAYMENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: paymentList.isEmpty ? _emptyPaymentList(context):
                ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(
                          color: Colors.white,
                        ),
                  padding: const EdgeInsets.all(8),
                  itemCount: paymentList.length,
                  itemBuilder: _getPaymentInfoList,
                ),
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Color(0xff207FC5),
                  label: Row(
                    children: <Widget>[
                      Text('ADD CARD'),
                      Icon(Icons.add,
                      size: 20,),
                    ],
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/addPayment');
                  },
                ),
              );
      }
    );
  }


Widget _getPaymentInfoList(BuildContext context, int index){
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff207FC5),
        boxShadow: [
          BoxShadow(
              color: Colors.black54,
              blurRadius: 5.0,
              offset: Offset(0,2)
          )
        ]
      ),
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(Icons.credit_card,
                        color: Colors.white,
                        size: 30,),
                        Text('  **** **** **** ${paymentList[index].cardNumber.substring(0,(4))}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text('MM/YY: ${paymentList[index].monthYear}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14
                      ),),
                  ],
                )

              ],
            ),
            SizedBox(height: 10),
            Text('Card holder: ${paymentList[index].cardHolderName}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 14
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState((){
                      parkCollection
                          .document(globalUser.uid)
                          .collection('paymentinfo')
                          .document(paymentList[index].cardNumber)//streetName
                          .delete();
                    });
                  },
                  child: Icon(Icons.delete,
                  color: Colors.white,
                  size: 25,),
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
                    fontWeight: FontWeight.w600
                )),
          ],
        )
      ],
    ),
  );
}

getPaymentInformation(AsyncSnapshot<QuerySnapshot> snapshot){
  return snapshot.data.documents.map((doc){
    String cardNumber = doc.data['cardNumber'];
    String cvcCode = doc.data['cvcCode'];
    String monthYear = doc.data['monthYear'];
    String cardHolderName = doc.data['cardHolderName'];
    return PaymentModel(
      cardNumber: cardNumber,
      cvcCode: cvcCode,
      cardHolderName: cardHolderName,
      monthYear: monthYear
    );
  }).toList();
}
}