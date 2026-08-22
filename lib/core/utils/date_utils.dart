import 'package:intl/intl.dart';

/// Date formatting utilities used across the app.
abstract final class AppDateUtils {
  static final _dateFormatter = DateFormat('MMM d, yyyy');
  static final _shortDateFormatter = DateFormat('MMM d');
  static final _timeFormatter = DateFormat('h:mm a');
  static final _dayFormatter = DateFormat('EEEE, MMMM d');

  static String formatDate(DateTime date) => _dateFormatter.format(date);
  static String formatShortDate(DateTime date) => _shortDateFormatter.format(date);
  static String formatTime(DateTime date) => _timeFormatter.format(date);
  static String formatDayLong(DateTime date) => _dayFormatter.format(date);

  static String greetingDate(DateTime date) {
    // "Wednesday, October 25th"
    final df = DateFormat('EEEE, MMMM');
    final day = date.day;
    final suffix = _daySuffix(day);
    return '${df.format(date)} $day$suffix';
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    return switch (day % 10) { 1 => 'st', 2 => 'nd', 3 => 'rd', _ => 'th' };
  }

  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isUpcoming(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    return d.isAfter(today);
  }

  static String relativeDate(DateTime date) {
    if (isToday(date)) return 'Today';
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    final diff = date.difference(DateTime.now()).inDays;
    if (diff < 7) return DateFormat('EEEE').format(date);
    return formatShortDate(date);
  }
}
