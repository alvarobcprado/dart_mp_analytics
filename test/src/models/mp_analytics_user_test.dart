import 'package:dart_mp_analytics/src/models/mp_analytics_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'MPAnalyticsUser',
    () {
      test(
        'setId sets the user id and returns true for valid id',
        () {
          final user = MPAnalyticsUser();
          expect(user.setId('user123'), isTrue);
          expect(
            user.data,
            {'user_id': 'user123'},
          );
        },
      );

      test(
        'setId does not set the user id and throws AssertionError for '
        'invalid id',
        () {
          final user = MPAnalyticsUser();
          expect(() => user.setId('a' * 257), throwsA(isA<AssertionError>()));

          expect(
            user.data,
            hasLength(0),
          );
        },
      );

      test(
        'clearId clears the user id',
        () {
          final user = MPAnalyticsUser()
            ..setId('user123')
            ..clearId();

          expect(
            user.data,
            hasLength(0),
          );
        },
      );

      test(
        'setProperty sets the user property and returns true for valid key '
        'and value',
        () {
          final user = MPAnalyticsUser();
          expect(user.setProperty('key', 'value'), isTrue);
          expect(
            user.data,
            {
              'user_properties': {
                'key': {'value': 'value'},
              },
            },
          );
        },
      );

      test(
        'setProperty does not set the user property and throws AssertionError '
        'for invalid key',
        () {
          final user = MPAnalyticsUser();

          expect(
            () => user.setProperty('a' * 25, 'value'),
            throwsA(isA<AssertionError>()),
          );

          expect(
            user.data,
            hasLength(0),
          );
        },
      );

      test(
        'setProperty does not set the user property and returns throws '
        'AssertionError for too many properties',
        () {
          final user = MPAnalyticsUser();
          for (var i = 0; i < 25; i++) {
            expect(user.setProperty('key$i', 'value$i'), isTrue);
          }

          expect(
            () => user.setProperty('key25', 'value25'),
            throwsA(isA<AssertionError>()),
          );

          expect(user.data['user_properties'], hasLength(25));
        },
      );

      test(
        'removeProperty removes the user property',
        () {
          final user = MPAnalyticsUser()
            ..setProperty('key', 'value')
            ..removeProperty('key');
          expect(user.data, hasLength(0));
        },
      );
    },
  );
}
