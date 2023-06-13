class Alarm {
  final int hours;
  final int minutes;
  final int frequency;
  late List<DateTime> nextAlarmTimes;

  Alarm({
    required this.hours,
    required this.minutes,
    required this.frequency,
  }) {
    setNextAlarmTimes();
  }

  void setNextAlarmTimes() {
    final now = DateTime.now();
    final selectedDateTime =
        DateTime(now.year, now.month, now.day, hours, minutes);

    nextAlarmTimes = [];

    for (int i = 0; i < frequency; i++) {
      DateTime nextAlarmTime =
          selectedDateTime.add(Duration(hours: i * (24 ~/ frequency)));

      if (nextAlarmTime.isBefore(now)) {
        nextAlarmTime = nextAlarmTime.add(Duration(days: 1));
      }

      nextAlarmTimes.add(nextAlarmTime);
    }
  }
}
