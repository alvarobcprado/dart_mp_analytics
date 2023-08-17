import 'package:dart_mp_analytics/src/models/mp_analytics_options.dart';

/// {@macro mp_analytics_options_mobile}
class MPAnalyticsOptionsMobile extends MPAnalyticsOptions {
  /// {@macro mp_analytics_options_mobile}
  const MPAnalyticsOptionsMobile({
    required this.firebaseAppId,
    required this.appInstanceId,
    required super.apiSecret,
  });

  /// The Firebase App ID. The identifier for a Firebase app. Found in the
  /// Firebase console under:
  ///
  /// Project Settings > General > Your Apps > App ID.
  final String firebaseAppId;

  /// The App Instance ID for your Firebase project.
  final String appInstanceId;

  @override
  Map<String, Object> get bodyParameters => {
        'app_instance_id': appInstanceId,
      };

  @override
  Map<String, Object> get urlParameters => {
        'api_secret': apiSecret,
        'firebase_app_id': firebaseAppId,
      };
}
