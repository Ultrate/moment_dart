> An attempt to port moment.js to Dart.

## Features

Convert `DateTime` to human-readable text.
  - Relative duration
  - Calendar text
  - Formatted dates
  - Multiple localizations

## Getings started

Import the package
```dart
import 'package:moment_dart/moment_dart.dart';
```

Create Moment instance

```dart
final Moment now = Moment.now();

final Moment epoch = Moment(DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true));

final Moment bday = DateTime(2003, 6, 1, 5, 1).toMoment();
```

## Usage

### Relative durations

```dart
final Moment yesterday = Moment.now() - Duration(days: 1);

yesterday.fromNow(); // a day ago

// You can omit prefix/suffix
yesterday.fromNow(true); // a day

yesterday.from(yesterday - Duration(days: 365)); // a year ago
```

### Calendar dates
```dart

now.subtract(Duration(days: 1)).calendar();  // Yesterday
now.calendar();                              // Today
now.subtract(Duration(days: 1)).calendar();  // Tomorrow

// [reference] - defaults to Moment.now(), acts as an anchor.
// [omitHours] - omits the hour part. Hour part is formatted by "LT" token.
now.calendar(
  reference: (now - Duration(days: 1)),
  omitHours: true,
); // Tomorrow

// [const] removed to save visual space. Please prefer to use `const Duration()`
```

### Formatting
```dart
now.format("YYYY MMMM Do - hh:mm:ssa"); //2003 June 1st - 05:01:00am
now.format("LTS");                      //5:01:00 AM
now.format("dddd");                     //Sunday
now.format("MMM Do YY");                //Jun 1st 03
```

### Changing localization
Localization defaults to `MomentLocalizations.enUS()`

```dart
final Moment hangulday2022 = Moment(DateTime(2022,10,9), localization: MomentLocalizations.ko());

hangulday2022.format("ll"); // 2022년 10월 9일
hangulday2022.format("LL"); // 2022년 10월 9일
```

## Available Localization classes:

Localizations are classes that extend `MomentLocalization`

- LocalizationEnUs (English - United States) [en_US]
- LocalizationKorean (Korean) [ko]
- LocalizationGermanStandard (German) [de_DE]
- LocalizationMongolianCyrillic (Mongolian) [mn]
  - LocalizationMongolianTraditional (Mongolian) [mn]
  - LocalizationMongolianTraditionalNumbers (Uses traditional Mongolian numbers)

### Parsing
> ***COMING SOON 💫***

## Salt 🧂 and pepper

Moment provides an extension with set of useful functions. **Can be called on either `Moment` or `DateTime` instance**

```dart
final DateTime date = DateTime(2022,03,29);

//Returns the ISO Week number of the year
//
// [1,2,3,...,52,53]
date.week == 13; // true

// Returns the year according to ISO Week
date.weekYear == 2022; // true

// Returns the quarter of the year. [][Jan,Feb,Mar][Apr,May,Jun][Jul,Aug,Sep][Oct,Nov,Dec]
//
// [1,2,3,4]
date.quarter == 1; // true

// Returns if the [year] is leap year
date.isLeapYear == false; // true

/// Returns ordinal day of the year
/// 
/// [1,2,3,...,365,366]
date.dayOfYear == 88; // true
```

Read more about [ISO week on Wikipedia](https://en.wikipedia.org/wiki/ISO_week_date)

## Creating your own Localzation

Extend `MomentLocalization` class to get started.

Almost everything is declared as function, so you can freely achieve the unique features of your language.

**I highly recommend copying one of the existing implementations then work on top of it!**

```dart
CatLanguage extends MomentLocalization {
  @override
  String relative(Duration duration, [bool dropPrefixOrSuffix = false]) => "a two meow ago";

  @override
  String weekdayName(int i) => "Meowday #$i";

  @override
  String calendar(Moment moment, {Moment? reference, bool weekStartOnSunday = false, bool omitHours = false}) => "Last Meowday";

  /// Please refer to the [FormatterToken] enum for details.
  /// 
  /// It contains almost all of the tokens mentioned in https://momentjs.com/docs/#/parsing/string-format/
  Map<FormatterToken, FormatterTokenFn?> formats() => {};

  @override
  String languageCodeISO() => "meow";

  @override
  String endonym() => "Meow-meow meow";

  @override
  String locale() => "meow";

  @override
  String languageNameInEnglish() => "Cat tongue";
}
```

## Format Tokens

Encapsulate string in square brackets ([]) to escape.

| Type                      | Token  | Examples                               | Description                                                                                   |
| ------------------------- | ------ | -------------------------------------- | --------------------------------------------------------------------------------------------- |
| Month                     | M      | 1 2 ... 11 12                          |                                                                                               |
|                           | Mo     | 1st 2nd ... 11th 12th                  |                                                                                               |
|                           | MM     | 01 02 ... 11 12                        |                                                                                               |
|                           | MMM    | Jan Feb ... Nov Dec                    |                                                                                               |
|                           | MMMM   | January February ... November December |                                                                                               |
| Quarter of year           | Q      | 1 2 3 4                                |                                                                                               |
|                           | Qo     | 1st 2nd 3rd 4th                        |                                                                                               |
| Day of month              | D      | 1 2 ... 30 31                          |                                                                                               |
|                           | Do     | 1st 2nd ... 30th 31st                  |                                                                                               |
|                           | DD     | 01 02 ... 30 31                        |                                                                                               |
| Day of year               | DDD    | 1 2 ... 364 365                        |                                                                                               |
|                           | DDDo   | 1st 2nd ... 364th 365th                |                                                                                               |
|                           | DDDD   | 001 002 ... 364 365                    |                                                                                               |
| Day of week               | d      | 1 2 ...6 7                             | Moment.js uses \`0-6\`. However, we'll be using \`1-7\` to be in accordance with \[DateTime\] |
|                           | d\_o   | 1st 2nd ... 6th 7th                    | "do" is Dart language keyword                                                                 |
|                           | dd     | Mo Tu ... Sa Su                        |                                                                                               |
|                           | ddd    | Mon Tue ... Sat Sun                    |                                                                                               |
|                           | dddd   | Monday ... Saturday Sunday             |                                                                                               |
| Day of week (ISO)         | e      | 1 2 ... 6 7                            |                                                                                               |
| Week of year (ISO)        | w      | 1 2 ... 52 53                          |                                                                                               |
|                           | wo     | 1st 2nd ... 52nd 53rd                  |                                                                                               |
|                           | ww     | 01 02 ... 52 53                        |                                                                                               |
| Year                      | YY     | 70 71 ... 29 30                        |                                                                                               |
|                           | YYYY   | 1970 1971 ... 2029 2030                |                                                                                               |
| Era Year                  | y      | 1 2 ... 2020 ...                       |                                                                                               |
| Era                       | NN     | BC AD                                  | Abbr era name                                                                                 |
|                           | NNNN   | Before Christ, Anno Domini             | Full era name                                                                                 |
|                           | NNNNN  | BC AD                                  | Narrow era name                                                                               |
| Week year                 | gg     | 70 71 ... 29 30                        |                                                                                               |
|                           | gggg   | 1970 1971 ... 2029 2030                |                                                                                               |
| AM/PM                     | A      | AM PM                                  | UPPERCASE                                                                                     |
|                           | a      | am pm                                  | lowercase                                                                                     |
| Hour                      | H      | 0 1 ... 22 23                          |                                                                                               |
|                           | HH     | 00 01 ... 22 23                        |                                                                                               |
|                           | h      | 1 2 ... 11 12                          |                                                                                               |
|                           | hh     | 01 02 ... 11 12                        |                                                                                               |
|                           | k      | 1 2 ... 23 24                          |                                                                                               |
|                           | kk     | 01 02 ... 23 24                        |                                                                                               |
| Minute                    | m      | 0 1 ... 58 59                          |                                                                                               |
|                           | mm     | 00 01 ... 58 59                        |                                                                                               |
| Second                    | s      | 0 1 ... 58 59                          |                                                                                               |
|                           | ss     | 00 01 ... 58 59                        |                                                                                               |
| Fractional second         | S      | 0 1 ... 8 9                            |                                                                                               |
|                           | SS     | 00 01 ... 98 99                        |                                                                                               |
|                           | SSS    | 000 001 ... 998 999                    |                                                                                               |
|                           | SSSS   | 0000 0001 ... 9998,9999                |                                                                                               |
|                           | SSSSS  | 00000 00001 ... 99998,99999            |                                                                                               |
|                           | SSSSSS | 000000 000001 ... 999998,999999        |                                                                                               |
| Timezone                  | Z      | \-07:00 -06:00 ... +06:00 +07:00       |                                                                                               |
|                           | ZZ     | \-0700 -0600 ... +0600 +0700           |                                                                                               |
| Timezone name             | ZZZ    |                                        | Returns \[DateTime.timeZoneName\], result may not be consistent across platforms              |
| Unix timestamp in seconds | X      | 1654063960                             |                                                                                               |
| Unix timestamp            | x      | 1654063974620                          |                                                                                               |
| Localization Defaults     | l      | 9/4/1986                               | Date (in local format, shorter)                                                               |
|                           | L      | 09/04/1986                             | Date (in local format)                                                                        |
|                           | ll     | Sep 4 1986                             | Month name, day of month, year (shorter)                                                      |
|                           | LL     | September 04 1986                      | Month name, day of month, year                                                                |
|                           | lll    | Sep 4 1986 8:30 PM                     | Month name, day of month, year, time                                                          |
|                           | LLL    | September 04 1986 8:30 PM              | Month name, day of month, year, time                                                          |
|                           | llll   | Thu, Sep 4 1986 8:30 PM                | Day of week, month name, day of month, year, time (shorter)                                   |
|                           | LLLL   | Thursday, September 04 1986 8:30 PM    | Day of week, month name, day of month, year, time                                             |
|                           | LT     | 8:30 PM                                | Time (without seconds)                                                                        |
|                           | LTS    | 8:30:00 PM                             | Time (with seconds)                                                                           |


## TODO

- Add more localizations
- Implement parsing