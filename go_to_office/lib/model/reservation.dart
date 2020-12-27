class Reservation {
  String officeId;
  String seatId;
  String date;
  String startTime;
  String endTime;
  bool syncWithCalendar;

  Reservation(
      {this.officeId,
      this.seatId,
      this.date,
      this.startTime,
      this.endTime,
      this.syncWithCalendar});
}
