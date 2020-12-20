import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_to_office/model/Reservation.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

class ResourceSelection extends StatefulWidget {
  ResourceSelection({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ResourceSelectionState createState() => _ResourceSelectionState();
}

class _ResourceSelectionState extends State<ResourceSelection> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();

  DateTime selectedDate = DateTime.now();
  List<String> _locations = []; // Option 2
  String _selectedLocation; // Option 2
  bool isDisabled = true;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().add(hour: 1);
  Reservation reservation = Reservation();

  @override
  void initState() {
    super.initState();
    _setupLocations();
    readData();
    reservation = Reservation(
        date: selectedDate.toString(),
        startTime: _startTime.toString(),
        endTime: _endTime.toString(),
        seatName: _selectedLocation,
        syncWithCalendar: isDisabled);
  }

  void _setupLocations() async {
    // List<String> locations = await DatabaseService.getNeeds();
    List<String> locations = [
      'HotSeat1',
      'HotSeat2',
      'HotSeat3',
      'HotSeat4'
    ]; // Option 2
    setState(() {
      _locations = locations;
    });
  }

  void readData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        reservation.date = selectedDate as String;
      });
  }

  Future<void> _selectHour(BuildContext context) async {
    Future<TimeOfDay> selectedTimeRTL = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
    );
  }

  String _timeFormated(TimeOfDay time) {
    if (time == null) return "--:--";
    return "${time.hour.toString()}:${time.minute.toString()}";
  }

  Void _submitForm() {
    if (_formKey.currentState.validate()) {
      _bookASeat();
    }
  }

  Void _bookASeat() {
    debugPrint("Seat booked button clicked");
    debugPrint("Reservation details: " + reservation.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(left: 10.0),
          margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Text("Date"),
                  SizedBox(width: 100), // give it width
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                ],
              ),
              Divider(
                indent: 5.0,
                endIndent: 5.0,
                color: Colors.black,
              ),
              Row(
                children: [
                  Text("Time"),
                  SizedBox(width: 100), // give it width
                  RaisedButton(
                    child: Text(_timeFormated(_startTime)),
                    onPressed: () => TimeRangePicker.show(
                      context: context,
                      startTime: _startTime,
                      endTime: _endTime,
                      timeRangeViewType: TimeRangeViewType.start,
                      onSubmitted: (TimeRangeValue value) {
                        setState(() {
                          _startTime = value.startTime;
                          reservation.startTime = _startTime as String;
                          _endTime = value.endTime;
                          reservation.endTime = _endTime as String;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20), // give it width
                  RaisedButton(
                    child: Text(_timeFormated(_endTime)),
                    onPressed: () => TimeRangePicker.show(
                      timeRangeViewType: TimeRangeViewType.end,
                      context: context,
                      startTime: _startTime,
                      endTime: _endTime,
                      onSubmitted: (TimeRangeValue value) {
                        setState(() {
                          _startTime = value.startTime;
                          reservation.startTime = _startTime as String;
                          _endTime = value.endTime;
                          reservation.endTime = _endTime as String;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.black),
              Row(
                children: [
                  Text("Room"),
                  SizedBox(width: 100), // give it width
                  DropdownButton(
                    hint: Text(_locations[0]), // Not necessary for Option 1
                    value: _selectedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                        reservation.seatName = _selectedLocation;
                      });
                    },
                    items: _locations.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                ],
              ),
              Divider(color: Colors.black),
              Row(
                children: [
                  Text("Sync with calendar"),
                  SizedBox(width: 100), // give it width
                  Switch(
                      value: isDisabled,
                      onChanged: (check) {
                        setState(() {
                          isDisabled = check;
                          reservation.syncWithCalendar = isDisabled;
                        });
                      }),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child: Text("Book"),
                    onPressed: _submitForm,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return this.replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}
