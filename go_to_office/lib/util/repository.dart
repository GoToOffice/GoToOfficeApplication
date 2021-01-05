import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_to_office/model/office.dart';
import 'strings.dart';

abstract class Repository {
  Future initialize() async {}

  Future<String> register(String email, String password) async {}

  Future<String> signIn(String email, String password) async {}

  Future<String> signOut() async {}

  Future<List> fetchOffices() async {}

}

class FirebaseRepository implements Repository {
  FirebaseAuth _auth;

  @override
  Future initialize() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  @override
  Future<String> signOut() async {
    User user = _auth.currentUser;
    if (user == null) {
      return Strings.sign_out_failed;
    }
    await _auth.signOut();
    return Strings.sign_out_success;
  }

  @override
  Future<String> register(String _email, String _password) async {
    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: _email, password: _password);
    return userCredential.user.uid;
  }

  @override
  Future<String> signIn(String _email, String _password) async {
    UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: _email, password: _password);
    return userCredential.user.uid;
  }

  @override
  Future<List> fetchOffices() async {
    var snapshot = await FirebaseDatabase.instance.reference().child("offices").once();
    LinkedHashMap offices = snapshot.value;
    List<Office> list = List();
    offices.forEach((key, val) {
      list.add(Office(
          name: val['name'],
          description: val['description'],
          id: key,
          country: val['country']
      ));
    });
    return list;
  }



}

class ErrorPage extends StatelessWidget {
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
