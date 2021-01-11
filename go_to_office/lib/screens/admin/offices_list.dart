import 'package:flutter/material.dart';
import 'office.dart';
import '../../util/strings.dart';
import '../../model/office.dart';
import '../../util/repository.dart';

class OfficesListPage extends StatefulWidget {
  final Repository repository;
  const OfficesListPage({Key key, this.repository}) : super(key: key);

  @override
  _OfficesListPage createState() {
    return _OfficesListPage(repository);
  }
}

class _OfficesListPage extends State<OfficesListPage> {
  final Repository repository;
  _OfficesListPage(this.repository);
  static Future<List<Office>> officesList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOfficesListApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Text('we have data}');
            var officesListLocal = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  title: Text(Strings.offices),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ElevatedButton(
                      child: Text(Strings.add_new_office),
                      onPressed: () {
                        openOfficePage(Office(), context);
                      },
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: officesListLocal.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new GestureDetector(
                            onTap: () => openOfficePage(
                                officesListLocal[index], context),
                            child: Container(
                                height: 50,
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  '${officesListLocal[index].name}',
                                  style: TextStyle(fontSize: 18),
                                )),
                          );
                        })
                  ]),
                ));
          } else {
            return Transform.scale(
              scale: 0.1,
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  openOfficePage(Office office, context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return new OfficePage(myOffice: office, repository: repository);
        },
      ),
    );
  }

  Future<List<Office>> getOfficesListApi() async {
    final response = await repository.fetchOffices();
    return response;
  }
}
