import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'log_util.dart';

final Map<String, DateFormat> _dateFormatCache = {};
final NumberFormat _numberFormatEnUs = NumberFormat('#,###', 'en_US');

DateFormat _cachedDateFormat(String pattern, [String? locale]) {
  final key = '$pattern|${locale ?? ''}';
  return _dateFormatCache.putIfAbsent(
    key,
    () => DateFormat(pattern, locale),
  );
}

/// Utility class for date and time formatting and manipulation.
class DateTimeUtil {
  /// Default format for dates: yyyy-MM-dd
  static const String defaultDateFormat = 'yyyy-MM-dd';

  /// Default format for parsing date-time: yyyy-MM-dd HH:mm
  static const String defaultDateTimeParseFormat = 'yyyy-MM-dd HH:mm';

  /// Default format for displaying date-time: yyyy-MM-dd hh:mm a
  static const String defaultDateTimeFormat = 'yyyy-MM-dd hh:mm a';

  /// Long date-time format with seconds.
  static const String formatDayMonthYearHourMinSec = 'dd MMM yyyy hh:mm:ss a';

  /// Standard sortable date-time format.
  static const String formatYearMonthDayHourMinSec = 'yyyy-MM-dd HH:mm:ss';

  /// Detailed format including weekday.
  static const String formatWeekDayMonthYear = 'EEEE, dd MMMM yyyy';

  /// US standard date format.
  static const String formatMMDDYYYY = 'MM/dd/yyyy';

  /// 12-hour time format with AM/PM.
  static const String formatHourMinAmPm = 'hh:mm a';

  /// International standard date format.
  static const String formatDDMMYYY = 'dd/MM/yyyy';

  /// Short month/day format.
  static const String formatMMDD = 'MM/dd';

  /// Short month name format.
  static const String formatMMM = 'MMM';

  static final RegExp _timezoneSuffixPattern =
      RegExp(r'([zZ]|[+-]\d{2}:?\d{2})$');

  /// Converts a UTC [DateTime] to local time.
  static DateTime convertDateToLocal(DateTime dateTime) =>
      dateTime.isUtc ? dateTime.toLocal() : dateTime;

  /// Parses API date strings that may already include a UTC suffix.
  static DateTime parseUtcDateTime(
    String value, {
    bool localized = true,
  }) {
    final String normalized = normalizeUtcDateString(value, localized: localized);
    return DateTime.parse(normalized);
  }

  /// Ensures UTC strings are parseable without duplicating timezone suffixes.
  static String normalizeUtcDateString(
    String value, {
    bool localized = true,
  }) {
    var trimmed = value.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    if (!localized) {
      return trimmed;
    }

    while (trimmed.endsWith('ZZ') || trimmed.endsWith('zz')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }

    final bool hasTimezone = _timezoneSuffixPattern.hasMatch(trimmed);
    return hasTimezone ? trimmed : '${trimmed}Z';
  }

  /// Returns a formatted date string.
  static String getFormattedDate(
    DateTime? dateTime, {
    String format = defaultDateTimeFormat,
    bool localized = true,
    String? locale,
  }) {
    if (dateTime == null) {
      return '';
    }
    try {
      final value = localized && dateTime.isUtc ? dateTime.toLocal() : dateTime;
      return _cachedDateFormat(format, locale).format(value);
    } catch (e) {
      LogUtil.logDefaultMsg('DateTimeUtil.getFormattedDate', e);
      return dateTime.toString();
    }
  }

  /// Parses and formats a date string.
  static String getFormatDayMonthYearHourMinSec(
    String? dateTime, {
    String format = defaultDateTimeFormat,
    bool localized = true,
    String? locale,
  }) {
    try {
      if (dateTime != null) {
        return _cachedDateFormat(format, locale).format(
          parseUtcDateTime(dateTime, localized: localized).toLocal(),
        );
      }
    } catch (e) {
      LogUtil.logDefaultMsg('DateTimeUtil.getFormatDayMonthYearHourMinSec', e);
    }
    return dateTime ?? '';
  }

  /// Formats a [DateTime] using [formatYearMonthDayHourMinSec].
  static String getFormatYearMonthDayHourMinSec(DateTime dateTime) {
    return _cachedDateFormat(formatYearMonthDayHourMinSec).format(dateTime);
  }

  /// Adds a number of months to a [DateTime].
  static DateTime addMonthsDateTime(DateTime dateTime, int months) {
    return dateTime.isUtc
        ? DateTime.utc(
            dateTime.year,
            dateTime.month + months,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
          )
        : DateTime(
            dateTime.year,
            dateTime.month + months,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
          );
  }

  /// Returns the current local time formatted as [formatHourMinAmPm].
  static String getCurrentHourMin() {
    return _cachedDateFormat(formatHourMinAmPm).format(DateTime.now().toLocal());
  }

  /// Returns the current UTC time formatted as [defaultDateTimeParseFormat].
  static String getCurrentUTCDateTime() {
    return _cachedDateFormat(defaultDateTimeParseFormat).format(
      DateTime.timestamp(),
    );
  }

  /// Checks if two dates fall in the same month and year.
  static bool isSameMonthAndYear(DateTime firstDate, DateTime secondDate) {
    return firstDate.month == secondDate.month &&
        firstDate.year == secondDate.year;
  }

  /// Checks if two dates represent the same day.
  static bool isSameDay(DateTime firstDate, DateTime secondDate) {
    return firstDate.month == secondDate.month &&
        firstDate.year == secondDate.year &&
        firstDate.day == secondDate.day;
  }

  /// Checks if two dates represent the same day and hour.
  static bool isSameDayAndHour(DateTime firstDate, DateTime secondDate) {
    return isSameDay(firstDate, secondDate) &&
        firstDate.hour == secondDate.hour;
  }

  /// Find the first date of the week which contains the provided date.
  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /// Find last date of the week which contains provided date.
  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(
      Duration(days: DateTime.daysPerWeek - dateTime.weekday),
    );
  }

  /// Find the first date of the month which contains the provided date.
  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  /// Find last date of the month which contains provided date.
  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return dateTime.month < 12
        ? DateTime(dateTime.year, dateTime.month + 1, 0)
        : DateTime(dateTime.year + 1, 1, 0);
  }

  /// Returns the date one day before [dateTime].
  static DateTime getOneDayBackward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
  }

  /// Returns the date one day after [dateTime].
  static DateTime getOneDayForward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
  }

  /// Returns a [DateTimeRange] for quick-filter keys:
  /// `today`, `yesterday`, `last_week`, `last_month`, `last_quarter`.
  static DateTimeRange getDateRangeByType(String type) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (type) {
      case 'today':
        start = end = DateTime(now.year, now.month, now.day);
        break;
      case 'yesterday':
        final y = now.subtract(const Duration(days: 1));
        start = end = DateTime(y.year, y.month, y.day);
        break;
      case 'last_week':
        final lastMonday = now.subtract(Duration(days: now.weekday + 6));
        start = DateTime(lastMonday.year, lastMonday.month, lastMonday.day);
        end = start.add(const Duration(days: 6));
        break;
      case 'last_month':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0);
        break;
      case 'last_quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final startMonth = (currentQuarter - 2) * 3 + 1;
        start = DateTime(now.year, startMonth, 1);
        end = DateTime(now.year, startMonth + 3, 0);
        break;
      default:
        start = end = DateTime(now.year, now.month, now.day);
    }

    return DateTimeRange(start: start, end: end);
  }

  /// Returns string in calendar format "yyyyMMdd".
  static String convertDateTimeYearMonthDay(DateTime dateTime) {
    return _cachedDateFormat('yyyyMMdd').format(dateTime);
  }

  /// Parses yyyyMMdd calendar strings produced by [convertDateTimeYearMonthDay].
  static DateTime parseCalenderToDateTime(String calender) {
    return _cachedDateFormat('yyyyMMdd').parse(calender.trim());
  }

  /// Converts minutes to "HH:mm" format.
  static String getTimeByIntegerMin(int minutes) {
    int hour = minutes ~/ 60;
    int min = minutes % 60;
    return '${hour.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}';
  }

  /// Formats a [Duration] as "HH:mm:ss".
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  /// Formats a number with comma separators.
  static String formatNumber(int number) => _numberFormatEnUs.format(number);

  /// Returns the current Unix timestamp in seconds.
  static int currentTimeStamp() =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

/// Extension for nullable [DateTime] null checks.
extension DateTimeNullExtension on DateTime? {
  /// Returns `true` when this value is `null`.
  bool get isNull => this == null;

  /// Returns `true` when this value is not `null`.
  bool get isNotNull => this != null;

  /// Converts this value to UTC, or returns `null` when this value is `null`.
  DateTime? asUtc() {
    final value = this;
    if (value == null) {
      return null;
    }
    return value.asUtc();
  }
}

/// Extensions on [DateTime] for common date manipulations.
extension DateTimeExtension on DateTime {
  /// Create a new date setting hour, minute and second to 0.
  DateTime startOfDay() =>
      _copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  /// Create a new date setting hour to 23, minute to 59, and second to 59.
  DateTime endOfDay() {
    final tomorrow = this.tomorrow().startOfDay();
    return tomorrow.subtract(const Duration(microseconds: 1));
  }

  /// Create a new date with yesterday values.
  DateTime yesterday() => subtract(const Duration(days: 1));

  /// Create a new date with tomorrow values.
  DateTime tomorrow() => add(const Duration(days: 1));

  /// Create a new first date of this week.
  DateTime firstDayOfWeek() => subtract(Duration(days: weekday - 1));

  /// Create a new last date of this week.
  DateTime lastDayOfWeek() =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  /// Create a new first date of this month.
  DateTime firstDayOfMonth() => subtract(Duration(days: day - 1));

  /// Create a new last date of this month.
  DateTime lastDayOfMonth() {
    final nextMonth = firstDayOfMonth().nextMonth();
    return nextMonth.subtract(const Duration(days: 1));
  }

  /// Create a new date with next month values.
  DateTime nextMonth() => _copyWith(month: month + 1);

  /// Create a new date with previous month values.
  DateTime previousMonth() => _copyWith(month: month - 1);

  /// Create a new date with next week values.
  DateTime nextWeek() => add(const Duration(days: DateTime.daysPerWeek));

  /// Create a new date with previous week values.
  DateTime previousWeek() =>
      subtract(const Duration(days: DateTime.daysPerWeek));

  /// Create a new date with next year values.
  DateTime nextYear() => _copyWith(year: year + 1);

  /// Create a new date with previous year values.
  DateTime previousYear() => _copyWith(year: year - 1);

  /// Create a new date with only date value (0 for hour, minute and second).
  DateTime onlyDate() =>
      _copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  /// Create a new date with only time value (0 for year, month and day).
  DateTime onlyTime() => _copyWith(year: 0, month: 0, day: 0);

  /// Returns `true` when this date falls on today (local calendar day).
  bool isToday() => DateTimeUtil.isSameDay(this, DateTime.now());

  /// Returns `true` when this date falls on yesterday (local calendar day).
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateTimeUtil.isSameDay(this, yesterday);
  }

  /// Returns `true` when this date falls on tomorrow (local calendar day).
  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DateTimeUtil.isSameDay(this, tomorrow);
  }

  /// Returns `true` when this date is before the current moment.
  bool get isInPast => isBefore(DateTime.now());

  /// Returns `true` when this date is after the current moment.
  bool get isInFuture => isAfter(DateTime.now());

  /// Adds [amount] days while preserving the time components.
  DateTime addDays(int amount) => DateTime(
    year,
    month,
    day + amount,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );

  /// Adds [amount] hours while preserving the other components.
  DateTime addHours(int amount) => DateTime(
    year,
    month,
    day,
    hour + amount,
    minute,
    second,
    millisecond,
    microsecond,
  );

  /// Returns `true` when this date is the first day of its month.
  bool isFirstDayOfMonth() => DateTimeUtil.isSameDay(this, firstDayOfMonth());

  /// Returns `true` when this date is the last day of its month.
  bool isLastDayOfMonth() => DateTimeUtil.isSameDay(this, lastDayOfMonth());

  /// Returns `true` when [other] falls in the same ISO week as this date.
  bool isSameWeek(DateTime other) =>
      DateTimeUtil.isSameDay(firstDayOfWeek(), other.firstDayOfWeek());

  /// Returns the day of the year (1 for January 1st, 365/366 for December 31st).
  int dayOfYear() {
    final startOfYear = DateTime(year, 1, 1);
    return difference(startOfYear).inDays + 1;
  }

  /// Returns the week number of the year, counting from January 1st.
  ///
  /// Does not follow strict ISO 8601 week numbering.
  int weekOfYear() {
    final startOfYear = DateTime(year, 1, 1);
    final daysSinceStart = difference(startOfYear).inDays;
    return (daysSinceStart / 7).ceil();
  }

  /// Returns the ISO 8601 week number of the year.
  ///
  /// Week 1 is the week containing the first Thursday of the year.
  int isoWeekOfYear() {
    final thursdayOfCurrentWeek = subtract(Duration(days: weekday - 4));
    final startOfYear = DateTime(thursdayOfCurrentWeek.year, 1, 1);
    final daysSinceStart = thursdayOfCurrentWeek.difference(startOfYear).inDays;
    return (daysSinceStart / 7).floor() + 1;
  }

  /// Returns the timezone offset formatted as `±HH:mm` (e.g. `+05:30`).
  String timeZoneOffSet() {
    final offset = timeZoneOffset;
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${offset.isNegative ? '-' : '+'}$hours:$minutes';
  }

  /// Returns the weekday name for this date.
  ///
  /// Set [isHalfName] to `true` for abbreviated names (e.g. "Mon").
  String weekdayName({bool isHalfName = false}) =>
      _cachedDateFormat(isHalfName ? 'EEE' : 'EEEE').format(this);

  /// Returns the month name for this date.
  ///
  /// Set [isHalfName] to `true` for abbreviated names (e.g. "Jan").
  String monthName({bool isHalfName = false}) =>
      _cachedDateFormat(isHalfName ? 'MMM' : 'MMMM').format(this);

  /// Returns the time in 12-hour AM/PM format (e.g. "02:30 Pm").
  String toTimeAmPm() {
    final time = TimeOfDay.fromDateTime(this);
    final hour = (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'Am' : 'Pm';
    return '$hour:$minute $period';
  }

  /// Returns this date as a Unix timestamp in seconds.
  int currentTimeStamp() => millisecondsSinceEpoch ~/ 1000;

  /// Returns elapsed seconds between this date and [differenceDateTime].
  ///
  /// Defaults to the current time when [differenceDateTime] is `null`.
  int countSeconds([DateTime? differenceDateTime]) {
    final difference =
        (differenceDateTime ?? DateTime.now()).millisecondsSinceEpoch -
        millisecondsSinceEpoch;
    return (difference / 1000).truncate();
  }

  /// Returns elapsed minutes between this date and [differenceDateTime].
  int countMinutes([DateTime? differenceDateTime]) {
    final difference =
        (differenceDateTime ?? DateTime.now()).millisecondsSinceEpoch -
        millisecondsSinceEpoch;
    return (difference / 60000).truncate();
  }

  /// Returns elapsed hours between this date and [differenceDateTime].
  int countHours([DateTime? differenceDateTime]) {
    final difference =
        (differenceDateTime ?? DateTime.now()).millisecondsSinceEpoch -
        millisecondsSinceEpoch;
    return (difference / 3600000).truncate();
  }

  /// Returns elapsed days between this date and [differenceDateTime].
  int countDays([DateTime? differenceDateTime]) {
    final difference =
        (differenceDateTime ?? DateTime.now()).millisecondsSinceEpoch -
        millisecondsSinceEpoch;
    return (difference / 86400000).truncate();
  }

  /// Returns elapsed weeks between this date and [differenceDateTime].
  int countWeeks([DateTime? differenceDateTime]) {
    final difference =
        (differenceDateTime ?? DateTime.now()).millisecondsSinceEpoch -
        millisecondsSinceEpoch;
    return (difference / 604800000).truncate();
  }

  /// Returns elapsed months between this date and [differenceDateTime].
  int countMonths([DateTime? differenceDateTime]) {
    final other = differenceDateTime ?? DateTime.now();
    final sign = isAfter(other) ? -1 : 1;
    final from = sign < 0 ? other : this;
    final to = sign < 0 ? this : other;
    var months = (to.year - from.year) * 12 + (to.month - from.month);
    if (to.day < from.day) {
      months--;
    }
    return sign * months;
  }

  /// Returns elapsed years between this date and [differenceDateTime].
  int countYears([DateTime? differenceDateTime]) {
    final other = differenceDateTime ?? DateTime.now();
    final sign = isAfter(other) ? -1 : 1;
    final from = sign < 0 ? other : this;
    final to = sign < 0 ? this : other;
    var years = to.year - from.year;
    if (to.month < from.month || (to.month == from.month && to.day < from.day)) {
      years--;
    }
    return sign * years;
  }

  /// Builds a UTC [DateTime] using this date's components.
  DateTime asUtc() => DateTime.utc(
    year,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );

  DateTime _copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) => DateTime(
    year ?? this.year,
    month ?? this.month,
    day ?? this.day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );
}
