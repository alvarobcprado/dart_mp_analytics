import 'package:http/http.dart' as http;

/// {@template mp_analytics_client}
/// A class that allows sending requests to the Google Analytics Measurement
/// Protocol.
///
/// The [logEvent] method is used to send requests to the Google Analytics
/// Measurement Protocol.
/// {@endtemplate}
class MPAnalyticsClient {
  /// {@macro mp_analytics_client}
  MPAnalyticsClient({
    required Map<String, Object> urlParameters,
    http.Client? client,
  }) {
    _initialize(
      client: client,
      urlParameters: urlParameters,
    );
  }

  late final http.Client _client;
  late final Map<String, Object> _urlParameters;
  late final Uri _baseUri;
  late final Uri _debugBaseUri;

  void _initialize({
    required Map<String, Object> urlParameters,
    http.Client? client,
  }) {
    _client = client ?? http.Client();
    _urlParameters = urlParameters;

    _baseUri = Uri(
      scheme: 'https',
      host: 'www.google-analytics.com',
      path: '/mp/collect',
      queryParameters: _urlParameters,
    );

    _debugBaseUri = _baseUri.replace(
      path: '/debug/mp/collect',
    );
  }

  /// Sends a request to the Google Analytics Measurement Protocol. The
  /// [eventBodyJson] parameter is a JSON string that contains the event data.
  ///
  /// The [debug] parameter is optional and defaults to false. When set to true,
  /// the [MPAnalyticsClient] will send requests to the debug endpoint instead
  /// of the normal endpoint. This will return a [http.Response] with the
  /// response from the validation server of the Google Analytics Measurement
  /// Protocol.
  ///
  /// See https://developers.google.com/analytics/devguides/collection/protocol/ga4/sending-events
  /// for more information on the eventBodyJson parameter.
  ///
  /// See https://developers.google.com/analytics/devguides/collection/protocol/ga4/validating-events
  /// for more information on the debug parameter.
  Future<http.Response?> logEvent(
    String eventBodyJson, {
    bool debug = false,
  }) async {
    if (debug) {
      return _logDebugEvent(eventBodyJson);
    }

    await _client.post(
      _baseUri,
      body: eventBodyJson,
    );
    return null;
  }

  Future<http.Response> _logDebugEvent(String eventBodyJson) async {
    return _client.post(
      _debugBaseUri,
      body: eventBodyJson,
    );
  }
}
