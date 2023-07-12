<div style="text-align: center; font-family: times new roman">
<h1>Dart MP Analytics</h1>
  <a href="https://pub.dev/packages/dart_mp_analytics"><img src="https://img.shields.io/pub/v/dart_mp_analytics.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/alvarobcpradodart_mp_analytics/actions"><img src="https://github.com/alvarobcprado/dart_mp_analytics/actions/workflows/test.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
    <a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="Very Good Analysis Style Badge"></a>
</div>


A Dart package for tracking and logging events to Google Analytics using the Measurement Protocol.

## Features

- Log events to Google Analytics Measurement Protocol
- Support for different platforms (mobile, web, etc.)
- Configurable options for API endpoints and settings
- Add custom metadata to events
- Debug mode for testing and validation of events before sending them to Google Analytics

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  dart_mp_analytics: ^1.0.0
```

Then, run `flutter pub get` to install the package.

## Usage

Import the package in your Dart code:

```dart
import 'package:dart_mp_analytics/dart_mp_analytics.dart';
```

Initialize the `MPAnalytics` instance with the desired options:

```dart
final mobileStreamOptions = MPAnalyticsOptions.mobileStream(
  firebaseAppId: 'your_firebase_app_id',
  appInstanceId: 'your_app_instance_id',
  apiSecret: 'your_api_secret',
);

final webStreamOptions = MPAnalyticsOptions.webStream(
  measurementId: 'your_measurement_id',
  clientId: 'your_client_id',
  apiSecret: 'your_api_secret',
);

final analytics = MPAnalytics(
  options: mobileStreamOptions // or webStreamOptions,
);
```

Log events using the `logEvent` method:

```dart
await analytics.logEvent('button_click');
```

For more advanced usage and customization, please refer to the package documentation.

## Documentation

Please refer to the [API documentation](https://pub.dev/documentation/dart_mp_analytics/latest/) for detailed information on the available classes and methods.

## Contributions

Contributions are welcome! If you find a bug or want to suggest an improvement, please open an issue or submit a pull request on the [GitHub repository](https://github.com/alvarobcprado/dart_mp_analytics).

## License

This package is released under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](https://github.com/alvarobcprado/dart_mp_analytics/blob/main/LICENSE) file for more details.