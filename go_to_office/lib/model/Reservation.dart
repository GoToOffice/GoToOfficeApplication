class Reservation {
  String date;
  String startTime;
  String endTime;
  String seatName;
  bool syncWithCalendar;

  Reservation(
      {this.date,
      this.startTime,
      this.endTime,
      this.seatName,
      this.syncWithCalendar});
}
