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

  Future<List<Office>> fetchOffices() async {}
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
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email, password: _password);
    return userCredential.user.uid;
  }

  @override
  Future<String> signIn(String _email, String _password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email, password: _password);
    return userCredential.user.uid;
  }

  @override
  Future<List<Office>> fetchOffices() async {
    await FirebaseDatabase.instance
        .reference()
        .child("offices")
        .once()
        .then((DataSnapshot snapshot) {
      LinkedHashMap offices = snapshot.value;
      List<Office> list = List();
      offices.forEach((key, val) {
        list.add(Office(
            name: val['name'],
            description: val['description'],
            id: key,
            country: val['country']));
      });
      return list;
    }).catchError((error) {
      print("Something went wrong: ${error.message}");
      return null;
    });
  }

  @override
  Future<bool> createOffice(Office newOffice) async {
    await FirebaseDatabase.instance
        .reference()
        .child(DateTime.now().toString())
        .set({
      'name': newOffice.name,
      'description': newOffice.description,
      'id': DateTime.now().toString(),
      'country': newOffice.country
    }).catchError((error) {
      print("Something went wrong: ${error.message}");
      return false;
    });
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
