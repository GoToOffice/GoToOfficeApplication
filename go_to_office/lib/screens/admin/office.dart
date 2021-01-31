import 'package:flutter/material.dart';
import 'package:go_to_office/main.dart';
import 'seat.dart';
import 'seats_list.dart';
import '../../util/strings.dart';
import '../../model/office.dart';
import '../../util/repository.dart';

class OfficePage extends StatefulWidget {
  OfficePage({this.office});
  Office office;
  @override
  State<StatefulWidget> createState() => _OfficePageState(office);
}

class _OfficePageState extends State<OfficePage> {
  final Office office;
  bool _isSaveButtonDisabled;

  _OfficePageState(this.office);
  @override
  void initState() {
    _isSaveButtonDisabled = false;
  }

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
                    initialValue: this.office.name,
                    decoration:
                        InputDecoration(hintText: Strings.insert_office_name),
                    onChanged: (String inputString) {
                      setState(() {
                        this.office.name = inputString;
                      });
                    }),
                TextFormField(
                    initialValue: this.office.country,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_country),
                    onChanged: (String inputString) {
                      setState(() {
                        this.office.country = inputString;
                      });
                    }),
                TextFormField(
                    initialValue: this.office.description,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_description),
                    onChanged: (String inputString) {
                      setState(() {
                        this.office.description = inputString;
                      });
                    }),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      child: Text(Strings.save),
                      onPressed: _isSaveButtonDisabled
                          ? null
                          : () {
                              updateOffice();
                            }),
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
                          builder: (context) => SeatsListPage(this.office.id)),
                    );
                  },
                ),
              ],
            )));
  }

  Future<bool> updateOffice() {
    if (FirebaseRepository != null) {
      return FirebaseRepository.updateOffice(this.office);
    } else {
      showMessage('problem connecting to DB', 'Error');
    }
  }
}
