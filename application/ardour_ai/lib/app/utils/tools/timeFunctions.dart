import 'package:intl/intl.dart';

bool isSameDate(int timestamp1, int timestamp2) {
  final date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
  final date2 = DateTime.fromMillisecondsSinceEpoch(timestamp2);

  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatSmartTimestamp(int timestamp, {String? today}) {
  final now = DateTime.now();
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

  final currentDay = DateTime(now.year, now.month, now.day);
  final yesterday = currentDay.subtract(Duration(days: 1));
  final inputDate = DateTime(date.year, date.month, date.day);

  if (inputDate == currentDay) {
    return today ?? DateFormat('hh:mm a').format(date); // 09:03 AM
  } else if (inputDate == yesterday) {
    return 'Yesterday';
  } else if (_isSameWeek(now, date)) {
    return DateFormat('EEEE').format(date); // Wednesday, etc.
  } else if (now.year == date.year) {
    return DateFormat('d MMMM').format(date); // 15 March
  } else {
    return DateFormat('d MMMM y').format(date); // 15 March 2023
  }
}

bool _isSameWeek(DateTime a, DateTime b) {
  final aMonday = a.subtract(Duration(days: a.weekday - 1));
  final bMonday = b.subtract(Duration(days: b.weekday - 1));
  return aMonday.year == bMonday.year &&
      aMonday.month == bMonday.month &&
      aMonday.day == bMonday.day;
}
