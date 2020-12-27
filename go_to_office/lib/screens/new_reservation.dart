import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_to_office/model/reservation.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

class NewReservation extends StatefulWidget {
  NewReservation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewReservationState createState() => _NewReservationState();
}

class _NewReservationState extends State<NewReservation> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();

  DateTime _selectedDate = DateTime.now();
  List<String> _offices = [];
  String _selectedOffice;

  List<String> _seats = [];
  String _selectedSeat;

  bool isDisabled = true;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().add(hour: 1);
  Reservation reservation = Reservation();

  @override
  void initState() {
    super.initState();
    updateOffices();
    reservation = Reservation(
        officeId: _selectedOffice,
        seatId: _selectedSeat,
        date: _selectedDate.toString(),
        startTime: _startTime.toString(),
        endTime: _endTime.toString(),
        syncWithCalendar: isDisabled);
  }

  void updateOffices() async {
    // List<Office> offices = await APIHandler.getOffices();
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   print('Data : ${snapshot.value}');
    // });

    List<String> offices = ['Office1', 'Office2', 'Office3']; // Option 2
    setState(() {
      _offices = offices;
      _selectedOffice = _offices[0];
    });

    updateSeats(_selectedOffice);
  }

  List<String> updateSeats(String officeId) {
    // List<Seat> seats = await APIHandler.getSeats(officeId);
    List<String> seats = ['HotSeat1', 'HotSeat2', 'HotSeat3', 'HotSeat4'];
    setState(() {
      _seats = seats;
    });
    return seats;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        reservation.date = _selectedDate as String;
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
    final officesDropDownButton = DropdownButton(
      hint: Text(_selectedOffice),
      value: _selectedOffice,
      onChanged: (newValue) {
        setState(() {
          _selectedOffice = newValue;
          reservation.officeId = _selectedOffice;
          _seats = updateSeats(_selectedOffice);
        });
      },
      items: _offices.map((location) {
        return DropdownMenuItem(
          child: new Text(location),
          value: location,
        );
      }).toList(),
    );

    final datePickerButton = RaisedButton(
      onPressed: () => _selectDate(context),
      child: Text("${_selectedDate.toLocal()}".split(' ')[0]),
    );

    final startTimeRangePickerButton = RaisedButton(
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
    );

    final endTimeRangePickerButton = RaisedButton(
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
    );

    final seatsDropDownPicker = DropdownButton(
      hint: Text(_seats[0]),
      value: _selectedSeat,
      onChanged: (newValue) {
        setState(() {
          _selectedSeat = newValue;
          reservation.seatId = _selectedSeat;
        });
      },
      items: _seats.map((location) {
        return DropdownMenuItem(
          child: new Text(location),
          value: location,
        );
      }).toList(),
    );

    final syncWithCalendarSwitchButton = Switch(
        value: isDisabled,
        onChanged: (check) {
          setState(() {
            isDisabled = check;
            reservation.syncWithCalendar = isDisabled;
          });
        });

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
                  Text("Office"),
                  SizedBox(width: 100),
                  officesDropDownButton,
                ],
              ),
              Divider(color: Colors.black),
              Row(
                children: [
                  Text("Date"),
                  SizedBox(width: 100),
                  datePickerButton,
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
                  SizedBox(width: 100),
                  startTimeRangePickerButton,
                  SizedBox(width: 20),
                  endTimeRangePickerButton,
                ],
              ),
              Divider(color: Colors.black),
              Row(
                children: [
                  Text("Seat"),
                  SizedBox(width: 100),
                  seatsDropDownPicker,
                ],
              ),
              Divider(color: Colors.black),
              Row(
                children: [
                  Text("Sync with calendar"),
                  SizedBox(width: 100),
                  syncWithCalendarSwitchButton,
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
