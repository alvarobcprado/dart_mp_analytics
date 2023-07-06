import 'package:dart_mp_analytics/dart_mp_analytics.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MPAnalyticsClient analyticsClient;
  late MockClient mockClient;
  late Uri baseUri;
  late Uri debugBaseUri;

  setUpAll(() {
    baseUri = Uri(
      scheme: 'https',
      host: 'www.google-analytics.com',
      path: '/mp/collect',
      queryParameters: {},
    );
    debugBaseUri = baseUri.replace(
      path: '/debug/mp/collect',
    );
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockClient();
    analyticsClient = MPAnalyticsClient(urlParameters: {}, client: mockClient);
  });

  test(
    'logEvent sends a request to the base URI',
    () async {
      when(() => mockClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      const eventBodyJson = '{"event": "example"}';
      await analyticsClient.logEvent(eventBodyJson);

      verify(
        () => mockClient.post(
          baseUri,
          body: eventBodyJson,
        ),
      ).called(1);
    },
  );

  test(
    'logEvent sends a request to the debug URI when debug is true',
    () async {
      when(() => mockClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      const eventBodyJson = '{"event": "example"}';
      await analyticsClient.logEvent(eventBodyJson, debug: true);

      verify(
        () => mockClient.post(
          debugBaseUri,
          body: eventBodyJson,
        ),
      ).called(1);
    },
  );

  test(
    'logEvent returns null when debug is false',
    () async {
      when(() => mockClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      const eventBodyJson = '{"event": "example"}';
      final result = await analyticsClient.logEvent(eventBodyJson);

      expect(result, isNull);
    },
  );

  test('logEvent returns a response when debug is true', () async {
    final response = http.Response('response body', 200);
    const eventBodyJson = '{"event": "example"}';

    when(() => mockClient.post(any(), body: any(named: 'body')))
        .thenAnswer((_) async => response);

    final result = await analyticsClient.logEvent(eventBodyJson, debug: true);

    expect(result, equals(response));
  });

  test(
    'uses the default client when none is provided',
    () async {
      analyticsClient = MPAnalyticsClient(urlParameters: {});

      when(() => mockClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      const eventBodyJson = '{"event": "example"}';

      await analyticsClient.logEvent(eventBodyJson);

      verifyNever(
        () => mockClient.post(
          baseUri,
          body: eventBodyJson,
        ),
      );
    },
  );
}
