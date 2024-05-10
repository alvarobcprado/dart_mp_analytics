// ignore_for_file: inference_failure_on_function_invocation

import 'package:dart_mp_analytics/dart_mp_analytics.dart';
import 'package:dart_mp_analytics/src/mp_analytics_client.dart';
import 'package:dart_mp_analytics/src/mp_analytics_user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockMPAnalyticsClient extends Mock implements MPAnalyticsClient {}

class MockMPAnalyticsUser extends Mock implements MPAnalyticsUser {}

class MockMPAnalyticsOptions extends Mock implements MPAnalyticsOptions {}

class MockMetadataService extends Mock implements MetadataService {}

void main() {
  late MPAnalytics analytics;
  late MPAnalyticsOptions options;
  late List<MetadataService> metadataServiceList;
  late bool debugAnalytics;
  late bool enabled;
  late MPAnalyticsClient client;
  late MPAnalyticsUser user;

  setUp(
    () {
      options = MockMPAnalyticsOptions();
      metadataServiceList = [MockMetadataService()];
      debugAnalytics = false;
      enabled = true;
      client = MockMPAnalyticsClient();
      user = MockMPAnalyticsUser();

      analytics = MPAnalytics(
        options: options,
        metadataServiceList: metadataServiceList,
        debugAnalytics: debugAnalytics,
        enabled: enabled,
      )..initializeMock(
          user: user,
          client: client,
        );
    },
  );

  group(
    'initialization',
    () {
      test(
        'initializes the MPAnalytics instance',
        () {
          when(() => options.bodyParameters).thenReturn({});
          when(() => options.urlParameters).thenReturn({});

          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: enabled,
          )..initialize();

          expect(analytics.isInitialized, isTrue);
        },
      );

      test(
        'does not initialize the MPAnalytics instance when disabled',
        () {
          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: false,
          )..initialize();

          expect(analytics.isInitialized, isFalse);
        },
      );

      test(
        'throws a StateError when trying to use the MPAnalytics before '
        'initializing',
        () {
          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: enabled,
          );

          expect(
            () => analytics.logEvent('event'),
            throwsA(isA<StateError>()),
          );
        },
      );
    },
  );

  group(
    'User',
    () {
      test(
        'setUserId sets the user ID',
        () {
          const userId = 'user123';

          when(() => user.setId(any())).thenReturn(true);

          analytics.setUserId(userId);

          verify(() => user.setId(userId)).called(1);
        },
      );

      test(
        'clearUserId clears the user ID',
        () {
          analytics.clearUserId();

          verify(() => user.clearId()).called(1);
        },
      );

      test(
        'setUserProperty sets the user property',
        () {
          const key = 'propertyKey';
          const value = 'propertyValue';

          when(() => user.setProperty(any(), any())).thenReturn(true);

          analytics.setUserProperty(key, value);

          verify(() => user.setProperty(key, value)).called(1);
        },
      );

      test(
        'removeUserProperty removes the user property',
        () {
          const key = 'propertyKey';

          analytics.removeUserProperty(key);

          verify(() => user.removeProperty(key)).called(1);
        },
      );

      test(
        'removeUserProperty do not remove property when disabled',
        () async {
          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: false,
          )..initializeMock(user: user, client: client);

          const key = 'propertyKey';

          analytics.removeUserProperty(key);

          verifyNever(() => user.removeProperty(key));
        },
      );

      test(
        'setUserProperty do not set property when disabled',
        () async {
          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: false,
          )..initializeMock(user: user, client: client);

          const key = 'propertyKey';
          const value = 'propertyValue';

          analytics.setUserProperty(key, value);

          verifyNever(() => user.setProperty(key, value));
        },
      );

      test(
        'setUserId do not set user ID when disabled',
        () async {
          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: false,
          )..initializeMock(user: user, client: client);

          const userId = 'userId';

          analytics.setUserId(userId);

          verifyNever(() => user.setId(userId));
        },
      );

      test(
        'clearUserId do not clear user ID when disabled',
        () async {
          MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: false,
          )
            ..initializeMock(user: user, client: client)
            ..clearUserId();

          verifyNever(() => user.clearId());
        },
      );
    },
  );

  group(
    'logEvent',
    () {
      test(
        'logs an event',
        () async {
          const eventName = 'event';
          const eventParameters = {'param1': 'value1', 'param2': 'value2'};
          const optionsBodyParameters = {'bodyKey': 'bodyValue'};
          const metadata = {'metadataKey': 'metadataValue'};
          const userData = {'userIdKey': 'userIdValue'};

          when(() => user.data).thenReturn(userData);
          when(() => options.bodyParameters).thenReturn(optionsBodyParameters);
          when(() => metadataServiceList[0].getMetadata())
              .thenAnswer((_) async => metadata);
          when(() => client.logEvent(any(), debug: any(named: 'debug')))
              .thenAnswer((_) async => null);

          await analytics.logEvent(eventName, parameters: eventParameters);

          verify(() => metadataServiceList[0].getMetadata()).called(1);
          verify(() => user.data).called(1);
          verify(
            () => client.logEvent(
              any(),
              debug: debugAnalytics,
            ),
          ).called(1);
        },
      );

      test(
        'does not log event when disabled',
        () async {
          analytics = MPAnalytics(
            options: options,
            metadataServiceList: metadataServiceList,
            debugAnalytics: debugAnalytics,
            enabled: false,
          )..initializeMock(user: user, client: client);

          const eventName = 'event';
          const parameters = {'param1': 'value1', 'param2': 'value2'};

          await analytics.logEvent(eventName, parameters: parameters);

          verifyNever(() => metadataServiceList[0].getMetadata());
          verifyNever(() => user.data).called(0);
          verifyNever(() => client.logEvent(any(), debug: any(named: 'debug')))
              .called(0);
        },
      );

      test(
        'throws a AssertionError if try to log invalid event',
        () {
          const invalidEventName = 'invalid event';
          const validParameters = {'param1': 'value1', 'param2': 'value2'};

          expect(
            () => analytics.logEvent(
              invalidEventName,
              parameters: validParameters,
            ),
            throwsA(isA<AssertionError>()),
          );

          const validEventName = 'valid_event';
          final invalidParameters = {
            'param1': 'value1',
            'param2': 'value2',
            'invalid': 'a' * 101,
          };

          expect(
            () => analytics.logEvent(
              validEventName,
              parameters: invalidParameters,
            ),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    },
  );
}
