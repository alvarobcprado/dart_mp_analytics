import 'package:dart_mp_analytics/src/models/mp_analytics_options_mobile.dart';
import 'package:test/test.dart';

void main() {
  group('MPAnalyticsOptionsMobile', () {
    const firebaseAppId = 'your_firebase_app_id';
    const appInstanceId = 'your_app_instance_id';
    const apiSecret = 'your_api_secret';

    test('bodyParameters returns the correct map', () {
      const options = MPAnalyticsOptionsMobile(
        firebaseAppId: firebaseAppId,
        appInstanceId: appInstanceId,
        apiSecret: apiSecret,
      );

      final bodyParameters = options.bodyParameters;

      expect(bodyParameters, {'app_instance_id': appInstanceId});
    });

    test('urlParameters returns the correct map', () {
      const options = MPAnalyticsOptionsMobile(
        firebaseAppId: firebaseAppId,
        appInstanceId: appInstanceId,
        apiSecret: apiSecret,
      );

      final urlParameters = options.urlParameters;

      expect(urlParameters, {
        'api_secret': apiSecret,
        'firebase_app_id': firebaseAppId,
      });
    });
  });
}
