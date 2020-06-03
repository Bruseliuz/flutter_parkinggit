import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:flutterparkinggit/services/pages/homescreens/settings_anon_drawer.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();

  String _currentCardNumber = '';
  String _currentDateMonth = '';
  String _currentCVC = '';
  String _currentCardHolder = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xff207FC5),
                elevation: 0.0,
                title: Text(
                  'PARK´N STOCKHOLM',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'PAYMENT',
                              style: TextStyle(
                                  color: Color(0xff207FC5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Text(
                                  'CARD NUMBER',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            TextFormField(
                              validator: (val) =>
                                  val.length < 16 && val.length > 16
                                      ? "Cardnumber, 12 numbers."
                                      : null,
                              onChanged: (val) {
                                setState(() {
                                  _currentCardNumber = val.trim();
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: '**** **** **** ****',
                                  contentPadding: EdgeInsets.only(top: 15),
                                  prefixIcon: Icon(
                                    Icons.credit_card,
                                    color: Color(0xff207FC5),
                                  )),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text(
                                  'DATE MM/YY',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 240),
                              child: TextFormField(
                                validator: (val) =>
                                    val.length < 4 ? "DD/YY" : null,
                                onChanged: (val) {
                                  setState(() {
                                    _currentDateMonth = val;
                                  });
                                },
                                decoration: InputDecoration(),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text(
                                  'CVC code',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 240),
                              child: TextFormField(
                                  validator: (val) =>
                                      val.length < 3 ? "Three numbers" : null,
                                  onChanged: (val) {
                                    setState(() => _currentCVC = val);
                                  },
                                  decoration: InputDecoration(
                                    hintText: '***',
                                    hintStyle: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  obscureText: true,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Cardholders Name',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 15),
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Color(0xff207FC5),
                                ),
                              ),
                              validator: (val) =>
                                  val.length < 1 ? "Enter a name" : null,
                              onChanged: (val) {
                                setState(() => _currentCardHolder = val);
                              },
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
              floatingActionButton: FloatingActionButton.extended(
                elevation: 3.0,
                backgroundColor: Color(0xff207FC5),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await DatabaseService(uid: user.uid).updateUserPaymentCard(
                        _currentCardNumber,
                        _currentDateMonth,
                        _currentCVC,
                        _currentCardHolder);
                    Navigator.pushReplacementNamed(context, '/payment');
                  }
                },
                label: Text('SAVE'),
                icon: Icon(Icons.save),
              ),
            );
          } else {
            return SettingsFormAnonDrawer();
          }
        });
  }
}
