import 'package:flutter/material.dart';
import 'package:go_to_office/screens/resource_selection.dart';

class Meetings extends StatefulWidget {
  Meetings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
