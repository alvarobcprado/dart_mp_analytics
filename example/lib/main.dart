import 'dart:io';

import 'package:dart_mp_analytics/dart_mp_analytics.dart';

void main() async {
  // Initialize MPAnalytics options
  // or use MPAnalyticsOptions.mobileStream()
  const options = MPAnalyticsOptions.webStream(
    clientId: 'your_client_id',
    measurementId: 'your_measurement_id',
    apiSecret: 'your_api_secret',
  );

  // Create an instance of MPAnalytics
  final analytics = MPAnalytics(
    options: options,
    debugAnalytics: true, // Enable debug mode for testing
    verbose: true, // Enable verbose logging
  )..initialize();

  // Log an event
  await analytics.logEvent(
    'button_click',
    parameters: {
      'button_id': 'submit_button',
      'page_name': 'home',
    },
  );

  // Set user ID
  analytics
    ..setUserId('user123')
    // Log another event with user properties
    ..setUserProperty('membership', 'gold');
  await analytics.logEvent(
    'purchase',
    parameters: {
      'product_id': 'product123',
      'price': 19.99,
    },
  );

  // Clear user ID and user property
  analytics
    ..clearUserId()
    ..removeUserProperty('membership');

  exit(0);
}
