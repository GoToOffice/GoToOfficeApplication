import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_to_office/screens/meetings.dart';

import '../util/repository.dart';
import '../util/strings.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.repository}) : super(key: key);

  final String title;
  final Repository repository;

  @override
  _LoginPageState createState() => _LoginPageState(repository);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState(this.repository);
  final Repository repository;

  void onUserLoggedIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Meetings(
            title: "Meetings",
          )),
    );
  }

  void onAdminLoggedIn() {
    // TBC -> Admin navigation Admin console
  }

  final _userTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Cleans up the controller when the widget is disposed.
    _userTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void _showSnack(String text) {
      _scaffoldKey.currentState.showSnackBar( SnackBar(content: Text(text)) );
    }

    void _showError(String text) {
      _scaffoldKey.currentState.showSnackBar( SnackBar(content: Text(text), backgroundColor: Colors.red) );
    }

    void _onError(Object error) {
      String text = "";
      if (error is FirebaseAuthException) {
        text = error.message;
      } else {
        text = error.toString();
      }
      _showError(text);
    }

    bool _userCredentialsValidation(String _email, String _password) {

      bool _validPassword = _password.isNotEmpty && _password.length > 5;
      bool _validEmail = _email.isNotEmpty && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);

      if (!_validEmail) {
        _onError(Strings.invalid_email);
        return false;
      }

      if (!_validPassword) {
        _onError(Strings.invalid_password);
        return false;
      }

      return true;
    }

    void _dispatchLogin(String pressedOption, String uid) {

      _showSnack("User had been successfully logged in" + uid);

      if (pressedOption == Strings.loginUser)
        onUserLoggedIn();
      else
        onAdminLoggedIn();

    }

    /// If the user is not registered, this method registers the user and then sign him in.
    void _onLoginRequest(String pressedOption) {

      String _email = _userTextController.text.toString();
      String _password = _passTextController.text.toString();

      if (_userCredentialsValidation(_email, _password)) {
        repository
            .signIn(_email, _password)
            .then((value) {
          _dispatchLogin(pressedOption, value);

        }, onError: (error) {

          if (error is FirebaseAuthException && error.code == "user-not-found") {
            repository
                .register(_email, _password)
                .then((value) {

              _dispatchLogin(pressedOption, value);

              }, onError: (error) {_onError(error);});

            return;

          }_onError(error);});
      }
    }

    final emailField = TextFormField(
      controller: _userTextController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: Strings.Email_hint,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      controller: _passTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: Strings.password_hint,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final userLoginButton = ElevatedButton(
      onPressed: () {
        _onLoginRequest(Strings.loginUser);
      },
      child: Text(
        Strings.loginUser,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).buttonColor),
      ),
    );

    final adminLoginButton = ElevatedButton(
      onPressed: () {
        _onLoginRequest(Strings.loginAdmin);
      },
      child: Text(
        Strings.loginAdmin,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).buttonColor),
      ),
    );

    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        Builder(builder: (BuildContext context) {
          return FlatButton(
            child: const Text(Strings.sign_out_button),
            textColor: Theme.of(context).buttonColor,
            onPressed: () {
              repository.signOut().then((value) => { _showSnack(value) });
            },
          );
        })
      ],
    );

    return Scaffold(
        appBar: appBar,
        key: _scaffoldKey,
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

                    SizedBox(height: 45.0),

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
