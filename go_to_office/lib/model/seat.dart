import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Seat {
  String id;
  String location;
  String roomId;
  String officeId;

  Seat({this.id, this.location, this.roomId, this.officeId});
}
