import 'dart:math';

import 'package:dart_mp_analytics/src/core/event_validator.dart';
import 'package:dart_mp_analytics/src/core/reserved_events.dart';
import 'package:test/test.dart';

void main() {
  final validator = EventValidator();
  final reservedEventNames = reservedEvents.toList();
  group(
    'validateEventName',
    () {
      test(
        'returns true for valid event names',
        () {
          expect(validator.validateEventName('myEvent'), true);
          expect(validator.validateEventName('event123'), true);
        },
      );

      test(
        'throws AssertionError for reserved event names',
        () {
          expect(
            () => validator.validateEventName(
              reservedEventNames[Random().nextInt(reservedEventNames.length)],
            ),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'throws AssertionError for event names longer than '
        '40 characters',
        () {
          expect(
            () => validator.validateEventName('a' * 41),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'throws AssertionError for empty event names',
        () {
          expect(
            () => validator.validateEventName(''),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'throws AssertionError for event names with invalid '
        'characters',
        () {
          expect(
            () => validator.validateEventName('event name'),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    },
  );

  group(
    'validateEventParameters',
    () {
      test(
        'validateEventParameters returns true for valid parameters',
        () {
          final parameters = {'param1': 'value1', 'param2': 123};
          expect(validator.validateEventParameters(parameters), true);
        },
      );

      test(
        'validateEventParameters throws AssertionError for more than 25 '
        'parameters',
        () {
          final parameters = {
            for (final i in List.generate(26, (index) => index))
              'param$i': 'value$i',
          };
          expect(
            () => validator.validateEventParameters(parameters),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'validateEventParameters throws AssertionError for parameter keys '
        'longer than 40 characters',
        () {
          final parameters = {'a' * 41: 'value'};
          expect(
            () => validator.validateEventParameters(parameters),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'validateEventParameters throws AssertionError for parameter values '
        'longer than 100 characters',
        () {
          final parameters = {'param': 'a' * 101};
          expect(
            () => validator.validateEventParameters(parameters),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    },
  );
}
