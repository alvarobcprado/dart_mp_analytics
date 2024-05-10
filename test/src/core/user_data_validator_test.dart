import 'package:dart_mp_analytics/src/core/user_data_validator.dart';
import 'package:test/test.dart';

void main() {
  final validator = UserDataValidator();
  group(
    'validateUserProperty',
    () {
      test(
        'returns true for valid user properties',
        () {
          const property = MapEntry('key', 'value');
          expect(validator.validateUserProperty(property), true);
        },
      );

      test(
        'throws AssertionError for user property key longer than 24 characters',
        () {
          final property = MapEntry('a' * 25, 'value');
          expect(
            () => validator.validateUserProperty(property),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'throws AssertionError for user property value longer than 36 '
        'characters',
        () {
          final property = MapEntry('key', 'a' * 37);
          expect(
            () => validator.validateUserProperty(property),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    },
  );

  group(
    'validateUserID',
    () {
      test(
        'returns true for valid user IDs',
        () {
          const id = 'user123';
          expect(validator.validateUserId(id), true);
        },
      );

      test(
        'throws AssertionError for user ID longer than 256 characters',
        () {
          final id = 'a' * 257;
          expect(
            () => validator.validateUserId(id),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    },
  );
}
