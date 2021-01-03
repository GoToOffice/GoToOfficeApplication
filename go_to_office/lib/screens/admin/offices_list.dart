import 'package:flutter/material.dart';
import 'package:go_to_office/util/customwidgets/nav_drawer.dart';
import 'package:go_to_office/util/repository.dart';

import '../../model/office.dart';
import '../../util/strings.dart';
import 'office.dart';

final List<Office> officesList = [
  Office(name: 'Herzeliya', description: 'Herzeliya Office', id: '1'),
  Office(name: 'Budapest', description: 'Budapest Office', id: '2'),
  Office(name: 'Boston', description: 'Boston Office', id: '3')
];

class OfficesListPage extends StatefulWidget {
  OfficesListPage({Key key, this.title, this.repository, this.adminName}) : super(key: key);

  final String title;
  final Repository repository;
  final String adminName;

  @override
  State<StatefulWidget> createState() => _OfficesListPageState(repository, adminName);
}

class _OfficesListPageState extends State<OfficesListPage> {
  _OfficesListPageState(this.repository, this.adminName);

  final Repository repository;
  final String adminName;

  @override
  Widget build(BuildContext context) {
    // Object officateAssreddress = {};
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        drawer: NavDrawer(userType: Strings.loginAdmin, title: adminName, repository: repository),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ElevatedButton(
              child: Text(Strings.add_new_office),
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
                        child: Text(
                          '${officesList[index].name}',
                          style: TextStyle(fontSize: 18),
                        )),
                  );
                })
          ]),
        ));
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
