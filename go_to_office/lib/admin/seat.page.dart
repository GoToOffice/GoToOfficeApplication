import 'package:flutter/material.dart';

void main(seatId, officeId) {
  runApp(new MaterialApp(
    title: "Office Manager",
    home: new SeatPage(seatId, officeId),
  ));
}

class SeatPage extends StatefulWidget {

  SeatPage(this.seatId, this.officeId );
    final String seatId;
    final String officeId;

  @override
  State<StatefulWidget> createState() => _SeatPageState(seatId, officeId);
}

class _SeatPageState extends State<SeatPage> {
  final String seatId;
  final String officeId;
  String roomId ;
  String seatLocation ;
   _SeatPageState(this.seatId, this.officeId);
  @override
  Widget build(BuildContext context) {
    this.roomId = '1';
    if (this.seatId != null) {  // call API to get get office also get the office name
    this.seatLocation = 'Near a window';
  } else {
    this.seatLocation = '';
  }

    // Object officateAssreddress = {};
    return Scaffold(
        appBar: AppBar(
          title: Text("Seats Manager"),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                  TextFormField(
                  initialValue: this.seatLocation,
                    decoration: InputDecoration(
                        hintText: 'Please insert Seat Loaction in the room'),
                    onChanged: (String inputString) {
                      setState(() {
                        seatLocation = inputString;
                      });
                    }),
              ],
            )));
  }
}
