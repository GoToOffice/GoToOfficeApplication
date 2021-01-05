import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: "Office Manager",
    home: new OfficePage(),
  ));
}

class OfficePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OfficePageState();
}

class _OfficePageState extends State<OfficePage> {
  @override
  Widget build(BuildContext context) {
    String officeName = '';
    String officeState = '';

    // Object officateAssreddress = {};
    return Scaffold(
        appBar: AppBar(
          title: Text("Office Manager"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
            child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration( 
                hintText: 'Please insert Office name'
                ),
                onChanged: (String inputString) {
                setState(() {
                  officeName = inputString;
                });
              }),
              TextField(
                decoration: InputDecoration( 
                hintText: 'Please insert Office name'
                ),
                onChanged: (String inputString) {
                setState(() {
                  officeState = inputString;
                });
              }),

            ],
        )));
  }
}
