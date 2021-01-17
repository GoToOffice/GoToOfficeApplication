import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_to_office/screens/user_profile/profile_page.dart';
import 'package:go_to_office/util/repository.dart';
import 'package:go_to_office/util/strings.dart';

/// An independent Navigation Drawer to take place at the two main pages
class NavDrawer extends StatefulWidget {
  NavDrawer({Key key, this.userType, this.title, this.repository})
      : super(key: key);

  final String title;
  final String userType;
  final Repository repository;

  @override
  _NavDrawerState createState() => _NavDrawerState(userType, repository);
}

class _NavDrawerState extends State<NavDrawer> {
  _NavDrawerState(this.userType, this.repository);

  // We need the Repository here, in order to enable this widget to be independent.
  final Repository repository;
  final String userType;
  String _imageURL;

  @override
  void initState() {
    getAvatarURL();
    super.initState();
  }

  Future<void> getAvatarURL() async {
    String downloadURL = await repository.getAvatarUrl();

    setState(() {
      _imageURL = downloadURL;
    });
  }

  String getImageAsset() {
    if (userType == Strings.loginUser) return 'assets/user_48.png';
    return 'assets/admin_48.png';
  }

  String getProfilePic() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: <Widget>[
        ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      child: ClipOval(
                          child: _imageURL == null
                              ? Image.asset(getImageAsset(),
                                  fit: BoxFit.fill)
                              : CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: _imageURL,
                                  fit: BoxFit.fill,
                                ))),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              )),
          ListTile(
              title: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset('assets/user_profile_b_24.png'),
                      FlatButton(
                          child: Text(Strings.UserProfile,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16)),
                          onPressed: () => {
                                Navigator.pop(context),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfilePage(
                                              title: "User Profile",
                                              repository: repository,
                                            )))
                              }),
                    ],
                  )))
        ]),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            width: double.infinity,
            child: FlatButton(
              child:
                  Text(Strings.sign_out_button, style: TextStyle(fontSize: 16)),
              onPressed: () => {
                Navigator.pop(context),
                repository.signOut().then((value) => Navigator.pop(context))
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    ));
  }
}
