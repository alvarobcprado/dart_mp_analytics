import 'package:dart_mp_analytics/src/models/mp_analytics_options_mobile.dart';
import 'package:dart_mp_analytics/src/models/mp_analytics_options_web.dart';

/// {@template mp_analytics_options}
/// An abstract class that defines the interface for MPAnalytics options that
/// are used to configure the MPAnalytics client.
///
/// The [apiSecret] parameter is required and must be a valid API secret for
/// your Google Analytics stream to which you want to send events with the
/// Measurement Protocol.
/// {@endtemplate}
abstract class MPAnalyticsOptions {
  /// {@macro mp_analytics_options}
  const MPAnalyticsOptions({
    required this.apiSecret,
  });

  /// {@macro mp_analytics_options_mobile}
  /// The [MPAnalyticsOptions] implementation for the Google Analytics mobile
  /// streams.
  ///
  /// The [apiSecret] parameter is required and must be a valid API secret for
  /// your Mobile stream.
  ///
  /// The [firebaseAppId] parameter is required and must be a valid Firebase
  /// App ID for your Firebase project.
  ///
  /// The [appInstanceId] parameter is required and must be an unique identifier
  /// for a Firebase app instance.
  /// The app instance ID is a device-specific identifier and is used to
  /// identify a mobile app instance.
  /// {@endtemplate}
  const factory MPAnalyticsOptions.mobileStream({
    required String firebaseAppId,
    required String appInstanceId,
    required String apiSecret,
  }) = MPAnalyticsOptionsMobile;

  /// {@macro mp_analytics_options_web}
  /// The [MPAnalyticsOptions] implementation for the Google Analytics web
  /// streams.
  ///
  /// The [apiSecret] parameter is required and must be a valid API secret for
  /// your Web stream.
  ///
  /// The [measurementId] parameter is required and must be a valid Measurement
  /// ID for your web stream.
  ///
  /// The [clientId] parameter is required and must be an unique identifier for
  /// a client.
  /// {@endtemplate}
  const factory MPAnalyticsOptions.webStream({
    required String measurementId,
    required String clientId,
    required String apiSecret,
  }) = MPAnalyticsOptionsWeb;

  /// The API secret for your Google Analytics stream to which you want to send
  /// events with the Measurement Protocol.
  ///
  /// The API secret can be created in the Google Analytics console under:
  ///
  /// Admin > Data Streams > choose your stream > Measurement Protocol > Create
  final String apiSecret;

  /// Returns a [Map] of the URL parameters that will be used to send events
  Map<String, Object> get urlParameters;

  /// Returns a [Map] of the body parameters that will be used to send events
  Map<String, Object> get bodyParameters;
}
