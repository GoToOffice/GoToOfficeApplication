import 'package:flutter/material.dart';

import 'screens/login.dart';
import 'util/repository.dart';
import 'util/strings.dart';

void main() {
  runApp(GTOApp());
}

void showMessage(String text, String messageType) {
  var backgroundColor;
  switch (messageType.toLowerCase()) {
    case 'error':
      {
        backgroundColor = Colors.red;
      }
      break;
    case 'warning':
      {
        backgroundColor = Colors.yellow;
      }
      break;
    case 'error':
      {
        backgroundColor = Colors.green;
      }
      break;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text), backgroundColor: backgroundColor));
}

class GTOApp extends StatelessWidget {
  // This widget is the root of the application.

  final Repository firebaseAuth = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: firebaseAuth.initialize(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ErrorPage(title: 'Error'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(title: Strings.app_name, repository: firebaseAuth),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(); //-> TBD
      },
    );
  }
}
