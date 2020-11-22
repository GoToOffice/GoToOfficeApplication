import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_repo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.authManager}) : super(key: key);

  final String title;
  final Repository authManager;

  @override
  _LoginPageState createState() => _LoginPageState(authManager);
}

class _LoginPageState extends State<LoginPage> {

  String loginUser = "Login as User";
  String loginAdmin = "Login as Admin";

  final _userTextController = TextEditingController();
  final _passTextController = TextEditingController();

  _LoginPageState(this.authManager);
  final Repository authManager;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _userTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void showSnack(String text) {
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void onError(String text) {
      final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void _onLoginRequest(BuildContext context, String pressedOption) {

      if (pressedOption == loginUser) {
          authManager.signIn(_userTextController.text, _passTextController.text)
              .then((value) {
            showSnack(value);
          }, onError: (e){
              String text = "";
              if (e is FirebaseAuthException) {
                text = e.message;
              } else {
                text = e.toString();
              }
              onError(text);
          });
      }
    }

    final emailField = TextFormField(
      controller: _userTextController,
      keyboardType: TextInputType.emailAddress,
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
            onPressed: () {
              authManager.signOut().then((value) => {
                showSnack(value)
              });
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
