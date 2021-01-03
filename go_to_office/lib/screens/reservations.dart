import 'package:flutter/material.dart';
import 'package:go_to_office/screens/new_reservation.dart';
import 'package:go_to_office/util/customwidgets/nav_drawer.dart';
import 'package:go_to_office/util/repository.dart';
import '../util/strings.dart';

class Meetings extends StatefulWidget {
  Meetings({Key key, this.title, this.repository, this.userName}) : super(key: key);

  final String title;
  final Repository repository;
  final String userName;

  @override
  _MeetingsState createState() => _MeetingsState(repository, userName);
}

class _MeetingsState extends State<Meetings> {
  _MeetingsState(this.repository, this.userName);

  final Repository repository;
  final String userName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text(widget.title)),
      drawer: NavDrawer(userType: Strings.loginUser, title: userName, repository: repository),
      body: Container(
        padding: EdgeInsets.only(left: 10.0),
        margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResourceSelection(
                          title: "Book a Seat",
                        )),
              );
            },
            child: Text("+"),
          ),
        ),
      ),
    );
  }
}
