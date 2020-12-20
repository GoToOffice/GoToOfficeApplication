import 'package:flutter/material.dart';
import 'seat.page.dart';
import 'seatsList.dart';
import '../util/strings.dart';
import '../model/office.model.dart';


void main(id) {
  runApp(new MaterialApp(
    title: Strings.office_manager,
    home: new OfficePage(id),
  ));
}

class OfficePage extends StatefulWidget {
   final String id;
  OfficePage(this.id);
  @override
  State<StatefulWidget> createState() => _OfficePageState(id);
}

class _OfficePageState extends State<OfficePage> {
   final Office myOffice = Office();
   final String id; 
   _OfficePageState(this.id);
  @override
  Widget build(BuildContext context) {
  if (this.id != null) {  // call API to get get office
    getOfficeApi(this.id);    
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
                  initialValue: this.myOffice.name,
                    decoration:
                        InputDecoration(hintText: Strings.insert_office_name),
                    onChanged: (String inputString) {
                      setState(() {
                        myOffice.name = inputString;
                      });
                    }),
                TextFormField(
                  initialValue: this.myOffice.country,
                    decoration:
                        InputDecoration(hintText: Strings.insert_office_country),
                    onChanged: (String inputString) {
                      setState(() {
                        myOffice.country = inputString;
                      });
                    }),
                TextFormField(
                  initialValue: this.myOffice.description,
                    decoration: InputDecoration(
                        hintText: Strings.insert_office_description),
                    onChanged: (String inputString) {
                      setState(() {
                        myOffice.description = inputString;
                      });
                    }),
                    Align (
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        child: Text(Strings.save),
                        onPressed: () {
                          CreaetUpdateOffice();
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: Text(Strings.add_new_seat),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SeatPage(null, this.myOffice.id)),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: Text(Strings.view_list_seats),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SeatsListPage(this.myOffice.id)),
                        );
                      },
                    ),
              ],
            )));
    
  }
  CreaetUpdateOffice() {
      if (this.myOffice.id != null) {  
        this.UpdateOfficeApi();
      } else {
        this.createOfficeApi();
      }
    }
    UpdateOfficeApi(){

    }
    createOfficeApi(){

    }
    getOfficeApi(id) {
      myOffice = Office({name: 'Herz-name', description: 'Herz-Desc', country: 'Israel'});
    }
  
}
