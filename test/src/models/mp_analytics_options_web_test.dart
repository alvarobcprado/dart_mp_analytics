import 'package:dart_mp_analytics/src/models/mp_analytics_options_web.dart';
import 'package:test/test.dart';

void main() {
  group('MPAnalyticsOptionsWeb', () {
    const clientId = 'your_client_id';
    const measurementId = 'your_measurement_id';
    const apiSecret = 'your_api_secret';

    test('urlParameters returns the correct map', () {
      const options = MPAnalyticsOptionsWeb(
        clientId: clientId,
        measurementId: measurementId,
        apiSecret: apiSecret,
      );

      final urlParameters = options.urlParameters;

      expect(urlParameters, {
        'api_secret': apiSecret,
        'measurement_id': measurementId,
      });
    });

    test('bodyParameters returns the correct map', () {
      const options = MPAnalyticsOptionsWeb(
        clientId: clientId,
        measurementId: measurementId,
        apiSecret: apiSecret,
      );

      final bodyParameters = options.bodyParameters;

      expect(bodyParameters, {'client_id': clientId});
    });
  });
}
