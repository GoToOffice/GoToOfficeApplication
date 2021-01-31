import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Seat {
  String id;
  String chairType;
  String location;
  String roomId;
  String officeId;
  String type;

  Seat(
      {this.id,
      this.chairType,
      this.location,
      this.roomId,
      this.officeId,
      this.type});
}
