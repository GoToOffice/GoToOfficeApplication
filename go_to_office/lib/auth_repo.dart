import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


abstract class Repository {

  Future<String> initialize() async {}

  Future<String> signIn(String email, String password) async {}

  Future<String> signOut() async {}

}

class FirebaseRepository implements Repository {

  FirebaseAuth _auth;

  @override
  Future<String> initialize() async{
    await Firebase.initializeApp();
  }

  @override
  Future<String> signOut() async {

    final User user = _auth.currentUser;
    if (user == null) {
      return "No user logged in";
    }

    _auth.signOut();
    return "Signed out successfully";
  }

  @override
  Future<String> signIn(String _email, String _password) async {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _email,
          password: _password
      );
      return userCredential.user.uid;
  }

/*
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return "Signed in as ${userCredential.user.uid}";*/
  }

class ErrorPage extends StatelessWidget{

  ErrorPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200.0,
          child: Image.asset(
            "assets/error.jpg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

