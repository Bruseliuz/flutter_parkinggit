import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/favorites.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/setting_anon.dart';
import 'package:provider/provider.dart';



class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    String _currentCardNumber;
    String _currentDateMonth;
    String _currentCVC;


    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xff207FC5),
                elevation: 0.0,
                title: Text('PARK´N STOCKHOLM',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text('PAYMENT',
                              style: TextStyle(
                                  color:  Color(0xff207FC5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Text('CARD NUMBER',
                                  style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 12,
                                      fontWeight: FontWeight.w600

                                  ),
                                )
                              ],
                            ),
                            TextFormField(
                              onChanged: (val){
                                setState(() {
                                  _currentCardNumber = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: '**** **** **** ****',
                                  hintStyle: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 12,
                                  ),
                                  contentPadding: EdgeInsets.only(top: 15),
                                  prefixIcon: Icon(
                                    Icons.credit_card,
                                    color: Color(0xff207FC5),
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('DATE MM/YY',
                                  style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 12,
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 240),
                              child: TextFormField(
                                onChanged: (val){
                                  setState(() {
                                    _currentDateMonth = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: '0120',
                                  hintStyle: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 12,
                                  ),
                                ),
                                  inputFormatters:[
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('CVC code',
                                  style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 240),
                              child: TextFormField(
                                onChanged: (val){
                                  setState(() => _currentCVC = val);
                                },
                                  decoration: InputDecoration(
                                    hintText: '123',
                                    hintStyle: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontSize: 12,
                                    ),
                                  ),
                                obscureText: true,
                                  inputFormatters:[
                                    LengthLimitingTextInputFormatter(3),
                                  ]
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('Cardholders Name',
                                  style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 12,
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                            TextFormField(
                              initialValue: ('${userData.name}'),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 15),
                                  prefixIcon: Icon(
                                    Icons.perm_identity,
                                    color: Color(0xff207FC5),
                                  ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                        color: Color(0xff207FC5),
                                        width: 1.5
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('ADD CARD ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0
                                      ),
                                    ),
                                  ],
                                ),
                                color: Color(0xff207FC5),
                                elevation: 4.0,
                                onPressed: () async{
                                  print(_currentCVC);
                                  print(_currentDateMonth);
                                  print(_currentCardNumber);
                                  await DatabaseService(uid: user.uid).updateUserPaymentCard(
                                      _currentCardNumber,
                                      _currentDateMonth,
                                      _currentCVC);
                                },
                                padding: EdgeInsets.all(15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Text(
                                'Your card is always handled in a secure way.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }else{
            return SettingsFormAnon();
          }
        }
    );
  }
}