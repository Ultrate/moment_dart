import 'package:moment_dart/moment_dart.dart';

export 'time_range/custom.dart';
export 'time_range/day.dart';
export 'time_range/hour.dart';
export 'time_range/month.dart';
export 'time_range/pageable_range.dart';
export 'time_range/week.dart';
export 'time_range/year.dart';

abstract class TimeRange {
  const TimeRange();

  bool get isUtc;

  /// Start of the range (inclusive)
  DateTime get from;

  /// End of the range (inclusive)
  DateTime get to;

  DurationUnit? get unit;

  /// Returns true if [dateTime] is between [from] (inclusive) and [to] (inclusive)
  bool contains(DateTime dateTime) => from <= dateTime && dateTime <= to;

  /// Returns true if [this] contains [timeRange]
  bool containsRange(TimeRange timeRange) =>
      timeRange.from >= from && timeRange.to <= to;

  Duration get duration => to.difference(from);

  /// Unless you're using CustomTimeRange, this will always keep the
  /// properties like [year], [month] the same.
  ///
  /// TL;DR, the following is NOT same.
  ///
  /// * `TimeRange().toUtc().from != TimeRange().from.toUtc()`
  /// * `TimeRange().toUtc().to != TimeRange().to.toUtc()`
  ///
  /// For example,
  ///
  /// ```dart
  /// final yearRange = YearTimeRange(2022);
  ///
  /// print(yearRange.from.year); // 2022
  /// print(yearRagne.toUtc().from.year); // 2022
  /// ```
  /// But as DateTime(2022, DateTime.january, 1) can be in the year 2021 in
  /// certain timezones.
  /// ```dart
  /// print(yearRange.from.toUtc().year); // Depending on the time zone, 2021 or 2022
  /// ```
  TimeRange toUtc();

  /// In the local timezone
  static HourTimeRange thisHour() => HourTimeRange.fromDateTime(DateTime.now());

  /// In the local timezone
  static HourTimeRange nextHour() =>
      HourTimeRange.fromDateTime(Moment.startOfNextHour());

  /// In the local timezone
  static HourTimeRange lastHour() =>
      HourTimeRange.fromDateTime(Moment.startOfLastHour());

  /// In the local timezone
  static DayTimeRange today() => DayTimeRange.fromDateTime(DateTime.now());

  /// In the local timezone
  static DayTimeRange tomorrow() =>
      DayTimeRange.fromDateTime(Moment.startOfTomorrow());

  /// In the local timezone
  static DayTimeRange yesterday() =>
      DayTimeRange.fromDateTime(Moment.startOfYesterday());

  /// In the local timezone
  static LocalWeekTimeRange thisLocalWeek([int? weekStart]) =>
      LocalWeekTimeRange(DateTime.now().startOfLocalWeek(weekStart));

  /// In the local timezone
  static LocalWeekTimeRange nextLocalWeek([int? weekStart]) =>
      LocalWeekTimeRange(DateTime.now().startOfNextLocalWeek(weekStart));

  /// In the local timezone
  static LocalWeekTimeRange lastLocalWeek([int? weekStart]) =>
      LocalWeekTimeRange(DateTime.now().startOfLastLocalWeek(weekStart));

  /// In the local timezone
  static IsoWeekTimeRange thisIsoWeek() =>
      IsoWeekTimeRange(DateTime.now().startOfIsoWeek());

  /// In the local timezone
  static IsoWeekTimeRange nextIsoWeek() =>
      IsoWeekTimeRange(DateTime.now().startOfNextIsoWeek());

  /// In the local timezone
  static IsoWeekTimeRange lastIsoWeek() =>
      IsoWeekTimeRange(DateTime.now().startOfLastIsoWeek());

  /// In the local timezone
  static MonthTimeRange thisMonth() =>
      MonthTimeRange.fromDateTime(DateTime.now());

  /// In the local timezone
  static MonthTimeRange nextMonth() =>
      MonthTimeRange.fromDateTime(Moment.startOfNextMonth());

  /// In the local timezone
  static MonthTimeRange lastMonth() =>
      MonthTimeRange.fromDateTime(Moment.startOfLastMonth());

  /// In the local timezone
  static YearTimeRange thisYear() => YearTimeRange.fromDateTime(DateTime.now());

  /// In the local timezone
  static YearTimeRange nextYear() =>
      YearTimeRange.fromDateTime(Moment.startOfNextYear());

  /// In the local timezone
  static YearTimeRange lastYear() =>
      YearTimeRange.fromDateTime(Moment.startOfLastYear());

  static CustomTimeRange allTime() =>
      CustomTimeRange(Moment.minValue, Moment.maxValue);

  /// Will preserve the timezone information of [start]
  ///
  /// This is same as `CustomTimeRange(start, start + duration)`
  static CustomTimeRange fromStartAndDuration(
    DateTime start,
    Duration duration,
  ) {
    return CustomTimeRange(start, start + duration);
  }

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) return false;

    return other is TimeRange &&
        from == other.from &&
        to == other.to &&
        isUtc == other.isUtc;
  }

  @override
  int get hashCode => Object.hash(from, to, isUtc);

  /// You can reconstruct [this] by passing the return value to
  /// [TimeRange.parse].
  ///
  /// Serializes [DateTime] to ISO 8601 string, therefore preserves
  /// [from] and [to]'s timezone information.
  @override
  String toString() => encode();

  String encode() {
    if (this is HourTimeRange) {
      return "HourTimeRange@${from.toIso8601String()}";
    }
    if (this is DayTimeRange) {
      return "DayTimeRange@${from.toIso8601String()}";
    }
    if (this is IsoWeekTimeRange) {
      return "IsoWeekTimeRange@${from.toIso8601String()}";
    }
    if (this is LocalWeekTimeRange) {
      return "LocalWeekTimeRange@${from.toIso8601String()}";
    }
    if (this is MonthTimeRange) {
      return "MonthTimeRange@${from.toIso8601String()}";
    }
    if (this is YearTimeRange) {
      return "YearTimeRange@${from.toIso8601String()}";
    }

    return "CustomTimeRange@${from.toIso8601String()}@${to.toIso8601String()}";
  }

  String encodeShort() {
    final String fromTag = from.microsecondsSinceEpoch.toRadixString(36);

    if (this is HourTimeRange) {
      return "H#$fromTag";
    }
    if (this is DayTimeRange) {
      return "D#$fromTag";
    }
    if (this is IsoWeekTimeRange) {
      return "K#$fromTag";
    }
    if (this is LocalWeekTimeRange) {
      return "W#$fromTag";
    }
    if (this is MonthTimeRange) {
      return "M#$fromTag";
    }
    if (this is YearTimeRange) {
      return "Y#$fromTag";
    }

    return "C#$fromTag#${to.microsecondsSinceEpoch.toRadixString(36)}";
  }

  /// Parses string generated by [toString]
  ///
  /// Throws [FormatException] if the string is not in the correct format
  static TimeRange parse(String serialized) {
    final TimeRange? result = tryParse(serialized);

    if (result == null) {
      throw const FormatException(
        "Cannot parse TimeRange from serialized string",
      );
    }

    return result;
  }

  /// Parses string generated by [toString]
  ///
  /// Returns null in any case of failure
  static TimeRange? tryParse(String serialized) {
    if (serialized.contains("#")) {
      try {
        return _parseShort(serialized);
      } catch (e) {
        print("[moment_dart] Failed to parse short -> $serialized");
        return null;
      }
    }

    final List<String> parts = serialized.split("@");

    if (parts.length < 2) return null;

    final DateTime? from = DateTime.tryParse(parts[1]);
    final DateTime? to = parts.length > 2 ? DateTime.tryParse(parts[2]) : null;

    if (from == null) return null;
    if (parts.first == "CustomTimeRange" && to == null) return null;

    switch (parts[0]) {
      case "HourTimeRange":
        return HourTimeRange.fromDateTime(from);
      case "DayTimeRange":
        return DayTimeRange.fromDateTime(from);
      case "IsoWeekTimeRange":
        return IsoWeekTimeRange(from);
      case "LocalWeekTimeRange":
        return LocalWeekTimeRange(from);
      case "MonthTimeRange":
        return MonthTimeRange.fromDateTime(from);
      case "YearTimeRange":
        return YearTimeRange.fromDateTime(from);
      default:
        return CustomTimeRange(from, to!);
    }
  }

  /// Parses string generated by [toString]
  ///
  /// Returns null in any case of failure
  static TimeRange? _parseShort(String serialized) {
    final List<String> parts = serialized.split("#");

    if (parts.length < 2) return null;

    final DateTime from =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(parts[1], radix: 36));
    final DateTime? to = parts.length > 2
        ? DateTime.fromMicrosecondsSinceEpoch(int.parse(parts[2], radix: 36))
        : null;

    if (parts.first == "C" && to == null) return null;

    switch (parts[0]) {
      case "H":
        return HourTimeRange.fromDateTime(from);
      case "D":
        return DayTimeRange.fromDateTime(from);
      case "K":
        return IsoWeekTimeRange(from);
      case "W":
        return LocalWeekTimeRange(from);
      case "M":
        return MonthTimeRange.fromDateTime(from);
      case "Y":
        return YearTimeRange.fromDateTime(from);
      default:
        return CustomTimeRange(from, to!);
    }
  }

  /// Converts [TimeRange] into readable format.
  ///
  /// For example, `LocalWeekTimeRange(Moment.now())` will return "This week" in `en_US`
  ///
  /// - [localization] defaults to [Moment]'s default localization
  /// - [anchor] defaults to [DateTime.now()]
  /// - [useRelative] defaults to true
  String format({
    MomentLocalization? localization,
    DateTime? anchor,
    bool useRelative = true,
  }) {
    return (localization ?? Moment.defaultLocalization).range(
      this,
      anchor: anchor,
      useRelative: useRelative,
    );
  }
}
