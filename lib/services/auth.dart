import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _databaseReference = Firestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async{
    try{
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await checkUserInDB(user.uid, user.displayName);
      return _userFromFirebaseUser(user);
    }catch(e){
      return e.code;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password, String name) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //create a new document for the user with the uid
      await checkUserInDB(user.uid, name);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async{
    try{
      await _auth.signOut();
      return await googleSignIn.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  Future handleGoogleSignIn() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    await checkUserInDB(user.uid, user.displayName);
    return _userFromFirebaseUser(user);

  }

  Future<FacebookLoginResult> getFBLoginResult() async {
    final facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  Future handleFacebookSignIn() async {
    FacebookLoginResult facebookLoginResult = await getFBLoginResult();
    try {
      final accessToken = facebookLoginResult.accessToken.token;
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: accessToken);

        final result = await _auth.signInWithCredential(facebookAuthCred);
        final FirebaseUser user = result.user;

        await checkUserInDB(user.uid, user.displayName);

        print(user.displayName);
        return _userFromFirebaseUser(user);

      } else
        return null;
    } catch (e) {
      print(e);
    }

  }

  Future<int> checkUserInDB(String uid, String username) async {
    final snapshot = await _databaseReference.collection('parkingPreference').document(uid).get();
    if (snapshot == null || !snapshot.exists) {
      await _databaseReference.collection('parkingPreference').document(uid).setData({
        'maxPrice': 50,
        'name': username,
        'parkingPreference': 'No Preference',
        'radius': 150
      });
      return 1;
    } else {
       return 0;
    }

  }

}