import 'package:flutter/material.dart';
import 'seat.dart';
import '../../util/strings.dart';
import '../../model/seat.dart';
import '../../util/repository.dart';


final List<Seat> SeatsList = [
  Seat(location: 'Herzeliya', id: '1', roomId: '1'),
  Seat(location: 'Budapest', id: '2', roomId: '1'),
  Seat(location: 'Boston', id: '3', roomId: '1')
];

class SeatsListPage extends StatefulWidget {
  final Repository repository;
  SeatsListPage(this.officeId, this.repository);
  final String officeId;

  @override
  State<StatefulWidget> createState() => _SeatsListPageState(officeId, repository);
}

class _SeatsListPageState extends State<SeatsListPage> {
  final String officeId;
  final Repository repository;
  _SeatsListPageState(this.officeId, this.repository);
  @override
  Widget build(BuildContext context) {
    // Object officateAssreddress = {};
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.seats),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  child: Text(Strings.add_new_seat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeatPage(null, this.officeId, null, repository)),
                    );
                  },
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: SeatsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new GestureDetector(
                          onTap: () =>
                              openSeatPage(SeatsList[index].id, null, null),
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text('${SeatsList[index].id}',
                                        style: TextStyle(fontSize: 18))),
                                Expanded(
                                  child: Text('${SeatsList[index].location}',
                                      style: TextStyle(fontSize: 18)),
                                )
                              ],
                            ),
                          ));
                    })
              ],
            )));
  }

  openSeatPage(seatId, roomId, officeId) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return new SeatPage(seatId, officeId, null, repository);
        },
      ),
    );
  }
}
