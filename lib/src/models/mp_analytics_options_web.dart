import 'package:dart_mp_analytics/src/models/mp_analytics_options.dart';

/// {@macro mp_analytics_options_web}
class MPAnalyticsOptionsWeb extends MPAnalyticsOptions {
  /// {@macro mp_analytics_options_web}
  const MPAnalyticsOptionsWeb({
    required this.clientId,
    required this.measurementId,
    required super.apiSecret,
  });

  /// A unique identifier for a client.
  final String clientId;

  /// The measurement ID associated with a stream. Found in the Google
  /// Analytics UI under:
  ///
  /// Admin > Data Streams > choose your stream > Measurement ID
  final String measurementId;

  @override
  Map<String, Object> get urlParameters => {
        'api_secret': apiSecret,
        'measurement_id': measurementId,
      };

  @override
  Map<String, Object> get bodyParameters => {
        'client_id': clientId,
      };
}
