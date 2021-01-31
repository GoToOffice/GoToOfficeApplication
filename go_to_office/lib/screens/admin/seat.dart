import '../../model/seat.dart';
import 'package:flutter/material.dart';
import '../../util/repository.dart';

class SeatPage extends StatefulWidget {
  SeatPage(this.seat, this.officeId, this.roomId);
  final Seat seat;
  final String officeId;
  final String roomId;

  @override
  State<StatefulWidget> createState() => _SeatPageState(seat, roomId, officeId);
}

class _SeatPageState extends State<SeatPage> {
  final Seat seat;
  final String roomId;
  final String officeId;

  _SeatPageState(this.seat, this.roomId, this.officeId);
  @override
  Widget build(BuildContext context) {
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
                        this.seat.location = inputString;
                      });
                    }),
              ],
            )));
  }

  updateSeat() {}

  getSeat(id) {}
}
