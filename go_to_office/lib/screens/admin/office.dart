import 'package:flutter/material.dart';

import '../../util/strings.dart';
import 'seat.dart';
import 'seats_list.dart';

class OfficePage extends StatefulWidget {
  OfficePage(this.id);

  final String id;
  @override
  State<StatefulWidget> createState() => _OfficePageState(id);
}

class _OfficePageState extends State<OfficePage> {
  final String id;
  String officeName;
  String officeCoutnry;
  String officeDescription;
  _OfficePageState(this.id);
  @override
  Widget build(BuildContext context) {
    if (this.id != null) {
      // call API to get get office
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
          title: Text(Strings.office_manager),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                    initialValue: this.officeName,
                    decoration:
                        InputDecoration(hintText: Strings.insert_office_name),
                    onChanged: (String inputString) {
                      setState(() {
                        officeName = inputString;
                      });
                    }),
                TextFormField(
                    initialValue: this.officeCoutnry,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_country),
                    onChanged: (String inputString) {
                      setState(() {
                        officeCoutnry = inputString;
                      });
                    }),
                TextFormField(
                    initialValue: this.officeDescription,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_description),
                    onChanged: (String inputString) {
                      setState(() {
                        officeDescription = inputString;
                      });
                    }),
                ElevatedButton(
                  child: Text(Strings.add_new_seat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeatPage(null, this.id)),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text(Strings.view_list_seats),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeatsListPage(this.id)),
                    );
                  },
                ),
              ],
            )));
  }
}
