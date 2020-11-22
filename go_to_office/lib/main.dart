import 'package:flutter/material.dart';
import 'auth_repo.dart';
import 'login_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of the application.

  Repository firebaseAuth = FirebaseRepository();

  Widget getLoginPage() {
    firebaseAuth.initialize()
        .then((value) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: LoginPage(title: "oz", authManager: firebaseAuth),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    getLoginPage();
  }

  /*  if (snapshot.hasError) {
      throw snapshot.error;*//*
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ErrorPage(title: 'Error'),
    );*//*
    }

    if (snapshot.connectionState == ConnectionState.done) {
    _auth = FirebaseAuth.instance;
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: loginPage,
    );
    }

    // Otherwise, show something whilst waiting for initialization to complete
    return Container(); //-> TBD
  }
  } */
}