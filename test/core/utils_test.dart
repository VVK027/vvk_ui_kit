import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';
import 'package:vvk_ui_kit/src/core/utils/log_util.dart';

void main() {
  group('StringUtils', () {
    test('validEmail validates correctly', () {
      expect(StringUtils.validEmail('test@example.com'), isTrue);
      expect(StringUtils.validEmail('invalid-email'), isFalse);
    });

    test('getFirstName and getLastName work', () {
      expect(StringUtils.getFirstName('John Doe'), 'John');
      expect(StringUtils.getLastName('John Doe'), 'Doe');
      expect(StringUtils.getFirstName('Single'), 'Single');
      expect(StringUtils.getLastName('Single'), '');
    });

    test('getShortNamedString returns initials', () {
      expect(StringUtils.getShortNamedString('John Doe'), 'JD');
      expect(StringUtils.getShortNamedString('Single'), 'S');
    });
  });

  group('DateTimeUtil', () {
    test('isSameDay works', () {
      final date1 = DateTime(2023, 10, 27);
      final date2 = DateTime(2023, 10, 27, 10, 30);
      final date3 = DateTime(2023, 10, 28);

      expect(DateTimeUtil.isSameDay(date1, date2), isTrue);
      expect(DateTimeUtil.isSameDay(date1, date3), isFalse);
    });

    test('formatNumber adds commas', () {
      expect(DateTimeUtil.formatNumber(1000), '1,000');
      expect(DateTimeUtil.formatNumber(1000000), '1,000,000');
    });

    test('convertDateToLocal converts UTC without string round-trip', () {
      final utc = DateTime.utc(2023, 10, 27, 10, 30);
      final local = DateTimeUtil.convertDateToLocal(utc);
      expect(local.isUtc, isFalse);
      expect(local, utc.toLocal());

      final alreadyLocal = DateTime(2023, 10, 27, 10, 30);
      expect(DateTimeUtil.convertDateToLocal(alreadyLocal), alreadyLocal);
    });

    test('getFormattedDate formats DateTime directly', () {
      final dateTime = DateTime(2023, 10, 27, 14, 30);
      final formatted = DateTimeUtil.getFormattedDate(
        dateTime,
        format: DateTimeUtil.formatYearMonthDayHourMinSec,
        localized: false,
      );
      expect(formatted, '2023-10-27 14:30:00');
    });

    test('countMonths and countYears use calendar math', () {
      final from = DateTime(2022, 1, 15);
      final to = DateTime(2024, 3, 15);

      expect(from.countMonths(to), 26);
      expect(from.countYears(to), 2);
      expect(to.countMonths(from), -26);
      expect(to.countYears(from), -2);

      expect(from.countMonths(DateTime(2024, 3, 10)), 25);
    });
  });

  group('JsonUtils', () {
    test('asInt parses correctly', () {
      expect(JsonUtils.asInt(10), 10);
      expect(JsonUtils.asInt('20'), 20);
      expect(JsonUtils.asInt('abc', 5), 5);
    });

    test('asBool parses correctly', () {
      expect(JsonUtils.asBool(true), isTrue);
      expect(JsonUtils.asBool('true'), isTrue);
      expect(JsonUtils.asBool(1), isTrue);
      expect(JsonUtils.asBool(0), isFalse);
    });
  });

  group('PlatformUtil', () {
    test('platform checks do not throw', () {
      expect(PlatformUtil.isAndroid, isNotNull);
      expect(PlatformUtil.isIOS, isNotNull);
    });
  });

  group('LogUtil', () {
    test('log methods do not throw', () {
      LogUtil.logDefaultMsg('TAG', 'data');
      LogUtil.logMsg('TAG', 'data');
    });
  });

  group('Translations', () {
    test('tr replaces positional arguments', () {
      final translations = Translations({'greet': 'Hello {0}!'});
      expect(translations.tr('greet', args: ['Viivek']), 'Hello Viivek!');
    });
  });
}
