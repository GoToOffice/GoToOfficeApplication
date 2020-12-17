import 'package:flutter/material.dart';
import 'office.page.dart';
import '../strings.dart';

void main() {
  runApp(new MaterialApp(
    title: "Offices",
    home: new OfficesListPage(),
  ));
}
final List<Office> officesList = [
  Office(name: 'Herzeliya', description: 'Herzeliya Office', id: '1'),
  Office(name: 'Budapest', description: 'Budapest Office', id: '2'),
  Office(name: 'Boston', description: 'Boston Office', id: '3')];

class OfficesListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OfficesListPageState();
}

class _OfficesListPageState extends State<OfficesListPage> {
  @override
  Widget build(BuildContext context) {

    // Object officateAssreddress = {};
    return Scaffold(
        appBar: AppBar(
          title: Text("Offices"),
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column (
            mainAxisSize: MainAxisSize.min,
             children: <Widget>[
              ElevatedButton(
                child: Text('Add New Office'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OfficePage(null)),
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: officesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () => openOfficePage(officesList[index].id),
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(2),
                      child: Text('${officesList[index].name}',
                        style: TextStyle(fontSize: 18), 
                      )
                    ),
                  );
                }
              )
            ]),
          )
        );
  }

  openOfficePage(id) {
    Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) {
                  return new OfficePage(id);
                },
              ),
            );
  }
}

 class Office {
  String name;
  String description;
  String id;

  Office({this.name, this.description, this.id});
}
