import 'package:flutter/material.dart';
import 'package:go_to_office/util/strings.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key, this.userType, this.title, this.callback}) : super(key: key);

  final String title;
  final String userType;
  final Function callback;

  @override
  _NavDrawerState createState() => _NavDrawerState(userType, callback);
}

class _NavDrawerState extends State<NavDrawer> {
  _NavDrawerState(this.userType, this.callback);

  final Function callback;
  final String userType;

  String getImageAsset() {
    if (userType == Strings.loginUser) return 'assets/user_48.png';
    return 'assets/admin_48.png';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(getImageAsset(), width: 80, height: 80,),
                      SizedBox(height: 15,),
                      Text(widget.title,
                        style: TextStyle(color: Colors.white),)
                    ],
                  )
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(Strings.sign_out_button),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  callback(Strings.sign_out_button);
                },
              )
            ]
        )
    );
  }
}