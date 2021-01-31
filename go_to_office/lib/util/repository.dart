import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_to_office/main.dart';
import 'package:go_to_office/model/office.dart';
import 'package:go_to_office/model/seat.dart';

import 'strings.dart';

abstract class Repository {
  Future initialize() async {}

  static Future<FirebaseRepository> create() async {}

  Future<String> register(String email, String password) async {}

  Future<String> signIn(String email, String password) async {}

  Future<String> signOut() async {}

  Future<List<Office>> fetchOffices() async {}

  Future<bool> updateOffice(Office newOffice) async {}
}
class FirebaseRepository implements Repository {
  static FirebaseAuth _auth;
  FirebaseRepository._();
  static FirebaseRepository firebaseRepository;

  static Future<FirebaseRepository> create() async {
    firebaseRepository = FirebaseRepository._();
    await firebaseRepository.initialize();
    return firebaseRepository;
  }

  Future<void> initialize() async {
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
    var snapshot = await FirebaseDatabase.instance
        .reference()
        .child("offices")
        .once()
        .catchError((error) {
      print("Something went wrong: ${error.message}");
      return [];
    });
    LinkedHashMap offices = snapshot.value;
    List<Office> list = List();
    offices.forEach((key, val) {
      list.add(Office(
        name: val['name'],
        country: val['country'],
        description: val['description'],
        id: key,
      ));
    });
    return list;
  }

  @override
  Future<bool> updateOffice(Office newOffice) async {
    final office = {
      'name': newOffice.name,
      'description': newOffice.description,
      'country': newOffice.country
    };
    if (newOffice.id.isEmpty ?? true) {
      await FirebaseDatabase.instance
          .reference()
          .child("offices")
          .push()
          .set(office)
          .catchError((error) {
        showMessage("Something went wrong: ${error.message}", 'Error');
        return false;
      });
    } else {
      await FirebaseDatabase.instance
          .reference()
          .child("offices")
          .child(newOffice.id)
          .set(office)
          .then((v) {
        showMessage("Office was saved succesfuly", 'Message');
      }).catchError((error) {
        showMessage("Something went wrong: ${error.message}", 'Error');
      });
    }
  }
}

Future<List<Seat>> fetchSeatsByOfficeId(String officeID) async {
    List<Seat> list = List();
    if (officeID.isEmpty) {
      return list;
    }
    var snapshot = await FirebaseDatabase.instance
        .reference()
        .child("seats")
        .child(officeID)
        .once();
    LinkedHashMap seats = snapshot.value;
    if (seats != null) {
      seats.forEach((key, val) {
        list.add(Seat(
            id: key,
            chairType: val["chairType"],
            location: val["location"],
            roomId: val["roomId"],
            type: val["type"]));
      });
    }
    return list;
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
