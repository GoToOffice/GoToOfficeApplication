import 'package:flutter/material.dart';
import '../../model/seat.dart';

void main(seatId, officeId, roomId) {
  runApp(new MaterialApp(
    title: "Office Manager",
    home: new SeatPage(seatId, officeId, roomId),
  ));
}

class SeatPage extends StatefulWidget {
  final String seatId;
  final String officeId;
  final String roomId;
  SeatPage(this.seatId, this.officeId, this.roomId);

  @override
  State<StatefulWidget> createState() =>
      _SeatPageState(seatId, officeId, roomId);
}

class _SeatPageState extends State<SeatPage> {
  String seatId;
  final String officeId;
  final String roomId;
  final mySeat = new Seat(id: '1', location: null, roomId: null);
  _SeatPageState(this.seatId, this.officeId, this.roomId);
  @override
  Widget build(BuildContext context) {
    if (this.seatId != null) {
      // call API to get get office
      getSeatApi(this.seatId);
    }
    //this.roomId = '1';
    if (this.seatId != null) {
      // call API to get get office also get the office name
      //this.seatLocation = 'Near a window';
    } else {
      //this.seatLocation = '';
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
                    decoration: InputDecoration(
                        hintText: 'Please insert Seat Loaction in the room'),
                    onChanged: (String inputString) {
                      setState(() {
                        this.mySeat.location = inputString;
                      });
                    }),
              ],
            )));
  }

  creaetUpdateSeat() {
    if (this.seatId != null) {
      this.updateSeateApi();
    } else {
      this.createSeatApi();
    }
  }

  updateSeateApi() {}
  createSeatApi() {}
  getSeatApi(id) {}
}
