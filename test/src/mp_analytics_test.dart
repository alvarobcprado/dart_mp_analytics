// ignore_for_file: inference_failure_on_function_invocation

import 'package:dart_mp_analytics/dart_mp_analytics.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockMPAnalyticsClient extends Mock implements MPAnalyticsClient {}

class MockLogger extends Mock implements Logger {}

class MockMPAnalyticsOptions extends Mock implements MPAnalyticsOptions {}

class MockMetadataService extends Mock implements MetadataService {}

void main() {
  late MPAnalytics analytics;
  late MPAnalyticsOptions options;
  late List<MetadataService> metadataServiceList;
  late bool debugAnalytics;
  late bool enabled;
  late bool verbose;
  late Logger logger;
  late MPAnalyticsClient client;

  setUpAll(() {
    registerFallbackValue(Level.info);
  });

  setUp(() {
    options = MockMPAnalyticsOptions();
    metadataServiceList = [MockMetadataService()];
    debugAnalytics = false;
    enabled = true;
    verbose = true;
    logger = MockLogger();
    client = MockMPAnalyticsClient();

    analytics = MPAnalytics(
      options: options,
      metadataServiceList: metadataServiceList,
      debugAnalytics: debugAnalytics,
      enabled: enabled,
      verbose: verbose,
      logger: logger,
      client: client,
    );
  });

  test('setUserId sets the user ID', () {
    const userId = 'user123';

    analytics.setUserId(userId);

    verify(() => logger.log(Level.info, 'Set user ID: $userId')).called(1);
  });

  test('clearUserId clears the user ID', () {
    analytics.clearUserId();

    verify(() => logger.log(Level.info, 'Cleared user ID')).called(1);
  });

  test('setUserProperty sets the user property', () {
    const key = 'propertyKey';
    const value = 'propertyValue';

    analytics.setUserProperty(key, value);

    verify(() => logger.log(Level.info, 'Set user property: $key = $value'))
        .called(1);
  });

  test('removeUserProperty removes the user property', () {
    const key = 'propertyKey';

    analytics.removeUserProperty(key);

    verify(() => logger.log(Level.info, 'Removed user property: $key'))
        .called(1);
  });

  test('logEvent logs an event', () async {
    const eventName = 'event';
    const eventParameters = {'param1': 'value1', 'param2': 'value2'};
    const optionsBodyParameters = {'bodyKey': 'bodyValue'};
    const metadata = {'metadataKey': 'metadataValue'};

    when(() => options.bodyParameters).thenReturn(optionsBodyParameters);
    when(() => metadataServiceList[0].getMetadata())
        .thenAnswer((_) async => metadata);
    when(() => client.logEvent(any(), debug: any(named: 'debug')))
        .thenAnswer((_) async => null);

    await analytics.logEvent(eventName, parameters: eventParameters);

    verify(
      () => logger.log(
        Level.info,
        'Logging event: $eventName with parameters: $eventParameters',
      ),
    ).called(1);
    verify(() => metadataServiceList[0].getMetadata()).called(1);
    verify(
      () => client.logEvent(
        any(),
        debug: debugAnalytics,
      ),
    ).called(1);
    verify(() => logger.log(Level.info, 'Response: null')).called(1);
  });

  test('logEvent does not log event when disabled', () async {
    analytics = MPAnalytics(
      options: options,
      metadataServiceList: metadataServiceList,
      debugAnalytics: debugAnalytics,
      enabled: false,
      verbose: verbose,
      logger: logger,
      client: client,
    );

    const eventName = 'event';
    const parameters = {'param1': 'value1', 'param2': 'value2'};

    await analytics.logEvent(eventName, parameters: parameters);

    verify(
      () => logger.log(
        Level.info,
        'MPAnalytics disabled, not logging event: $eventName',
      ),
    ).called(1);
    verifyNever(() => metadataServiceList[0].getMetadata());
    verifyNever(() => client.logEvent(any(), debug: any(named: 'debug')))
        .called(0);
  });

  test(
    'MPAnalytics use default client when not provided',
    () async {
      const eventName = 'event';
      const eventParameters = {'param1': 'value1', 'param2': 'value2'};
      const optionsBodyParameters = {'bodyKey': 'bodyValue'};
      const optionsUrlParameters = {'urlKey': 'urlValue'};
      const metadata = {'metadataKey': 'metadataValue'};

      when(() => options.bodyParameters).thenReturn(optionsBodyParameters);
      when(() => options.urlParameters).thenReturn(optionsUrlParameters);
      when(() => metadataServiceList[0].getMetadata())
          .thenAnswer((_) async => metadata);
      when(() => client.logEvent(any(), debug: any(named: 'debug')))
          .thenAnswer((_) async => null);

      analytics = MPAnalytics(
        options: options,
        metadataServiceList: metadataServiceList,
        debugAnalytics: debugAnalytics,
        enabled: enabled,
        verbose: verbose,
        logger: logger,
      );

      await analytics.logEvent(eventName, parameters: eventParameters);

      verifyNever(
        () => client.logEvent(
          any(),
          debug: debugAnalytics,
        ),
      );
    },
  );

  test(
    'removeUserProperty do not remove property when disabled',
    () async {
      when(() => logger.log(any(), any())).thenReturn(null);

      analytics = MPAnalytics(
        options: options,
        metadataServiceList: metadataServiceList,
        debugAnalytics: debugAnalytics,
        enabled: false,
        verbose: verbose,
        logger: logger,
        client: client,
      );

      const key = 'propertyKey';

      analytics.removeUserProperty(key);

      verify(
        () => logger.log(
          Level.info,
          'MPAnalytics disabled, not removing user property: $key',
        ),
      ).called(1);
    },
  );

  test(
    'setUserProperty do not set property when disabled',
    () async {
      when(() => logger.log(any(), any())).thenReturn(null);

      analytics = MPAnalytics(
        options: options,
        metadataServiceList: metadataServiceList,
        debugAnalytics: debugAnalytics,
        enabled: false,
        verbose: verbose,
        logger: logger,
        client: client,
      );

      const key = 'propertyKey';
      const value = 'propertyValue';

      analytics.setUserProperty(key, value);

      verify(
        () => logger.log(
          Level.info,
          'MPAnalytics disabled, not setting user property: {$key : $value}',
        ),
      ).called(1);
    },
  );

  test(
    'setUserId do not set user ID when disabled',
    () async {
      when(() => logger.log(any(), any())).thenReturn(null);

      analytics = MPAnalytics(
        options: options,
        metadataServiceList: metadataServiceList,
        debugAnalytics: debugAnalytics,
        enabled: false,
        verbose: verbose,
        logger: logger,
        client: client,
      );

      const userId = 'userId';

      analytics.setUserId(userId);

      verify(
        () => logger.log(
          Level.info,
          'MPAnalytics disabled, not setting user ID: $userId',
        ),
      ).called(1);
    },
  );

  test(
    'clearUserId do not clear user ID when disabled',
    () async {
      when(() => logger.log(any(), any())).thenReturn(null);

      MPAnalytics(
        options: options,
        metadataServiceList: metadataServiceList,
        debugAnalytics: debugAnalytics,
        enabled: false,
        verbose: verbose,
        logger: logger,
        client: client,
      ).clearUserId();

      verify(
        () => logger.log(
          Level.info,
          'MPAnalytics disabled, not clearing user ID',
        ),
      ).called(1);
    },
  );
}
