import 'package:flutter/material.dart';
import 'seat.dart';
import 'seats_list.dart';
import '../../util/strings.dart';
import '../../model/office.dart';
import '../../util/repository.dart';

class OfficePage extends StatefulWidget {
  OfficePage({this.myOffice, this.repository});
  final Office myOffice;
  final Repository repository;
  @override
  State<StatefulWidget> createState() => _OfficePageState(myOffice, repository);
}

class _OfficePageState extends State<OfficePage> {
  final Office myOffice;
  final Repository repository;

  _OfficePageState(this.myOffice, this.repository);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.office_manager),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                    initialValue: this.myOffice.name,
                    decoration:
                        InputDecoration(hintText: Strings.insert_office_name),
                    onChanged: (String inputString) {
                      setState(() {
                        this.myOffice.name = inputString;
                      });
                    }),
                TextFormField(
                    initialValue: this.myOffice.country,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_country),
                    onChanged: (String inputString) {
                      setState(() {
                        this.myOffice.country = inputString;
                      });
                    }),
                TextFormField(
                    initialValue: this.myOffice.description,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_description),
                    onChanged: (String inputString) {
                      setState(() {
                        this.myOffice.description = inputString;
                      });
                    }),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    child: Text(Strings.save),
                    onPressed: () {
                      creaetUpdateOffice();
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text(Strings.add_new_seat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeatPage(null, null, null)),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text(Strings.view_list_seats),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeatsListPage(this.myOffice.id)),
                    );
                  },
                ),
              ],
            )));
  }

  Future<bool> creaetUpdateOffice() {
    if (repository != null) {
      return repository.createUpdateOffice(this.myOffice);
    }
  }
}
