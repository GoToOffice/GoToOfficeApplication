import 'package:flutter/material.dart';
import 'seat.page.dart';
import 'seatsList.dart';

void main(id) {
  runApp(new MaterialApp(
    title: "Office Manager",
    home: new OfficePage(id),
  ));
}

class OfficePage extends StatefulWidget {
  OfficePage(this.id);

  final String id;
  @override
  State<StatefulWidget> createState() => _OfficePageState(id);
}

class _OfficePageState extends State<OfficePage> {
  final String id;
  String officeName;
  String officeCoutnry ;
  String officeDescription;
   _OfficePageState(this.id);
  @override
  Widget build(BuildContext context) {
  if (this.id != null) {  // call API to get get office
    this.officeName = 'Herzeliya';
    this.officeCoutnry = 'Israel';
    this.officeDescription = 'Office description';
  } else {
    this.officeName = '';
    this.officeCoutnry = '';
    this.officeDescription = '';
  }

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
                TextFormField(
                  initialValue: this.officeName,
                    decoration:
                        InputDecoration(hintText: 'Please insert Office name'),
                    onChanged: (String inputString) {
                      setState(() {
                        officeName = inputString;
                      });
                    }),
                TextFormField(
                  initialValue: this.officeCoutnry,
                    decoration:
                        InputDecoration(hintText: 'Please insert Country'),
                    onChanged: (String inputString) {
                      setState(() {
                        officeCoutnry = inputString;
                      });
                    }),
                TextFormField(
                  initialValue: this.officeDescription,
                    decoration: InputDecoration(
                        hintText: 'Please insert Office Description'),
                    onChanged: (String inputString) {
                      setState(() {
                        officeDescription = inputString;
                      });
                    }),
                    ElevatedButton(
                      child: Text('Add New Seat'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SeatPage(null, this.id)),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: Text('View List of Seats'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SeatsListPage(this.id)),
                        );
                      },
                    ),
              ],
            )));
  }
}
