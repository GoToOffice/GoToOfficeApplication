import 'package:flutter/material.dart';
import 'package:go_to_office/util/repository.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key, this.title, this.repository}) : super(key: key);

  final String title;
  final Repository repository;

  @override
  _NavDrawerState createState() => _NavDrawerState(repository);
}

class _NavDrawerState extends State<NavDrawer> {
  _NavDrawerState(this.repository);

  final Repository repository;
  Stream authState;

  @override
  void initState() {
    authState = repository.getAuthChangesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Tap to Logout'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Logout',),
                  onTap: () {
                  repository.signOut();
                  Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('You are not logged in'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),ListTile()
            ],
            );
          }
          return Container();
        });
  }
}