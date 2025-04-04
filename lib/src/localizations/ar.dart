// ignore_for_file: file_names
// المؤلف: ultrate (https://github.com/ultrate)

import 'package:moment_dart/moment_dart.dart';
import 'package:moment_dart/src/localizations/mixins/month_names.dart';
import 'package:moment_dart/src/localizations/mixins/simple_duration.dart';
import 'package:moment_dart/src/localizations/mixins/simple_range.dart';
import 'package:moment_dart/src/localizations/mixins/simple_relative.dart';
import 'package:moment_dart/src/localizations/mixins/simple_units.dart';
import 'package:moment_dart/src/types.dart';

class LocalizationAr extends MomentLocalization
    with
        MonthNames,
        SimpleUnits,
        SimpleRelative,
        SimpleDuration,
        SimpleRange {
  static LocalizationAr? _instance;

  LocalizationAr._internal() : super();

  factory LocalizationAr() {
    _instance ??= LocalizationAr._internal();

    return _instance!;
  }

  @override
  String get endonym => "العربية";

  @override
  String get languageCode => "ar";

  @override
  String get countryCode => "";

  @override
  String get languageNameInEnglish => "Arabic";

  @override
  String relativePast(String unit) => "منذ $unit";
  @override
  String relativeFuture(String unit) => "في غضون $unit";

  @override
  Map<int, String> get monthNames => {
        1: "يناير",
        2: "فبراير",
        3: "مارس",
        4: "أبريل",
        5: "ماي",
        6: "يونيو",
        7: "يوليوز",
        8: "غشت",
        9: "شتنبر",
        10: "أكتوبر",
        11: "نونبر",
        12: "دجنبر",
      };

  @override
  Map<int, String> get monthNamesShort => {
        1: "ينا",
        2: "فبر",
        3: "مار",
        4: "أبر",
        5: "ماي",
        6: "يون",
        7: "يول",
        8: "غشت",
        9: "شتن",
        10: "أكت",
        11: "نون",
        12: "دجن",
      };

  @override
  Map<int, String> get weekdayName => {
        DateTime.monday: "الإثنين",
        DateTime.tuesday: "الثلاثاء",
        DateTime.wednesday: "الأربعاء",
        DateTime.thursday: "الخميس",
        DateTime.friday: "الجمعة",
        DateTime.saturday: "السبت",
        DateTime.sunday: "الأحد",
      };

  Map<int, String> get weekdayNameShort => {
        DateTime.monday: "إثن",
        DateTime.tuesday: "ثلا",
        DateTime.wednesday: "أرب",
        DateTime.thursday: "خمي",
        DateTime.friday: "جمعة",
        DateTime.saturday: "سبت",
        DateTime.sunday: "أحد",
      };

  @override
  FormatSetOptional overrideFormatters() {
    String getShortMonth(DateTime dt) => monthNamesShort[dt.month]!;
    String getShortWeekday(DateTime dt) => weekdayNameShort[dt.weekday]!;

    return {
      ...formattersForMonthNames,
      FormatterToken.L: (dateTime) => reformat(dateTime, "DD/MM/YYYY"),
      FormatterToken.l: (dateTime) => reformat(dateTime, "D/M/YYYY"),
      FormatterToken.LL: (dateTime) => reformat(dateTime, "D MMMM YYYY"),
      FormatterToken.ll: (dateTime) => "${dateTime.day} ${getShortMonth(dateTime)} ${dateTime.year}",
      FormatterToken.LLL: (dateTime) =>
          reformat(dateTime, "D MMMM YYYY HH:mm"),
      FormatterToken.lll: (dateTime) =>
          "${dateTime.day} ${getShortMonth(dateTime)} ${dateTime.year} ${format(dateTime, 'HH:mm')}",
      FormatterToken.LLLL: (dateTime) =>
          "${weekdayName[dateTime.weekday]}، ${format(dateTime, 'D MMMM YYYY HH:mm')}",
      FormatterToken.llll: (dateTime) =>
          "${getShortWeekday(dateTime)}، ${dateTime.day} ${getShortMonth(dateTime)} ${dateTime.year} ${format(dateTime, 'HH:mm')}",
      FormatterToken.LT: (dateTime) => reformat(dateTime, "HH:mm"),
      FormatterToken.LTS: (dateTime) => reformat(dateTime, "HH:mm:ss"),
    };
  }

  @override
  List<String> get ordinalSuffixes => [];

  @override
  CalenderLocalizationData get calendarData => calenderLocalizationDataAr;

  static String last(String weekday) => "$weekday الماضي";
  static String at(String date, String time) => "$date الساعة $time";

  static const CalenderLocalizationData calenderLocalizationDataAr =
      CalenderLocalizationData(
    relativeDayNames: {
      -1: "الأمس",
      0: "اليوم",
      1: "غداً",
    },
    keywords: CalenderLocalizationKeywords(
      at: at,
      lastWeekday: last,
    ),
  );

  @override
  int get weekStart => DateTime.saturday;

  @override
  Map<DurationInterval, UnitString> get units => {
        DurationInterval.lessThanASecond: UnitString.simple("بضع ثوان"),
        DurationInterval.aSecond: UnitString.simple("ثانية واحدة"),
        DurationInterval.seconds: UnitString.simple("$srDelta ثوانٍ"),
        DurationInterval.aMinute: UnitString.simple("دقيقة واحدة"),
        DurationInterval.minutes: UnitString.simple("$srDelta دقائق"),
        DurationInterval.anHour: UnitString.simple("ساعة واحدة"),
        DurationInterval.hours: UnitString.simple("$srDelta ساعات"),
        DurationInterval.aDay: UnitString.simple("يوم واحد"),
        DurationInterval.days: UnitString.simple("$srDelta أيام"),
        DurationInterval.aWeek: UnitString.simple("أسبوع واحد"),
        DurationInterval.weeks: UnitString.simple("$srDelta أسابيع"),
        DurationInterval.aMonth: UnitString.simple("شهر واحد"),
        DurationInterval.months: UnitString.simple("$srDelta أشهر"),
        DurationInterval.aYear: UnitString.simple("سنة واحدة"),
        DurationInterval.years: UnitString.simple("$srDelta سنوات"),
      };

  @override
  SimpleRangeData get simpleRangeData => SimpleRangeData(
        thisWeek: "هذا الأسبوع",
        year: (range, {DateTime? anchor, bool useRelative = true}) {
          anchor ??= Moment.now();
          if (useRelative && range.year == anchor.year) {
            return "هذا العام";
          }
          return "عام ${range.year}";
        },
        month: (range, {DateTime? anchor, bool useRelative = true}) {
          anchor ??= Moment.now();
          if (useRelative && anchor.year == range.year) {
            if (anchor.month == range.month) {
              return "هذا الشهر";
            }
            return monthNames[range.month]!;
          }
          return "${monthNames[range.month]!} ${range.year}";
        },
        allAfter: (formattedDate) => "بعد $formattedDate",
        allBefore: (formattedDate) => "قبل $formattedDate",
        customRangeAllTime: "كل الأوقات",
      );
}
