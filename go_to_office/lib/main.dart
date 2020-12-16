import 'package:flutter/material.dart';
import 'repository.dart';
import 'login_page.dart';
import 'strings.dart';

void main() {
  runApp(GTOApp());
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
