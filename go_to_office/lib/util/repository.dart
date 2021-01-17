import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'strings.dart';
import 'dart:io' as io;

abstract class Repository {

  Stream<dynamic> getAuthChangesStream();


  Future initialize() async {}

  Future<String> register(String email, String password) async {}

  Future<String> signIn(String email, String password) async {}

  Future<String> signOut() async {}

  Future<TaskSnapshot> uploadAvatar(File file) async {}

  Future<String> getAvatarUrl() async {}

}

class FirebaseRepository implements Repository {
  FirebaseAuth _auth;

  @override
  Future initialize() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    FirebaseAuth.instance.authStateChanges();
  }

  Future<String> getAvatarUrl() async {

    final ref = FirebaseStorage.instance.ref().child(_auth.currentUser.email);
    return await ref.getDownloadURL();
  }

  @override
  Future<TaskSnapshot> uploadAvatar(File file) async {

    if (file == null) {
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(_auth.currentUser.email);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
        uploadTask = ref.putFile(io.File(file.path), metadata);

    return Future.value(uploadTask);
  }

  @override
  Stream getAuthChangesStream() {
    return _auth.authStateChanges();
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
