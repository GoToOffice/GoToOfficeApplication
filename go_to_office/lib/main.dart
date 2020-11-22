import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
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
            home: LoginPage(title: 'Go to office'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(); //-> TBD
      },
    );
  }
}

class ErrorPage extends StatelessWidget{

  ErrorPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        "assets/error.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String loginUser = "Login as User";
  String loginAdmin = "Login as Admin";

  FirebaseAuth _auth = FirebaseAuth.instance;

  final _userTextController = TextEditingController();
  final _passTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _userTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }

  void login() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _userTextController.text,
          password: _passTextController.text
      );
      final snackBar = SnackBar(content: Text("User Logged in = ${userCredential.user}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      dispose();

    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.code));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    void _onLoginRequest(BuildContext context, String pressedOption) {

      if (pressedOption == loginUser) {
        login();
      } else {
        final snackBar = SnackBar(content: Text(pressedOption));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Orly's implementation
      }

    }

    final emailField = TextField(
      obscureText: true,
      controller: _userTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      controller: _passTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final userLoginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          _onLoginRequest(context, loginUser);
          },

        child: Text(loginUser,
            textAlign: TextAlign.center
        ),
      ),
    );

    final adminLoginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          _onLoginRequest(context, loginAdmin);
          },

        child: Text(loginAdmin,
            textAlign: TextAlign.center
        ),
      ),
    );

    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        Builder(builder: (BuildContext context) {

          return FlatButton(
            child: const Text('Sign out'),
            textColor: Theme
                .of(context)
                .buttonColor,
            onPressed: () async {
              final User user = _auth.currentUser;
              if (user == null) {
                final snackBar = SnackBar(content: Text('No one has signed in.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
              await _auth.signOut();
              final String uid = user.uid;
              final snackBar = SnackBar(content: Text(uid + ' has successfully signed out.'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        })
      ],
    );

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    userLoginButton,
                    SizedBox(
                      height: 15.0,
                    ),
                    adminLoginButton,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
