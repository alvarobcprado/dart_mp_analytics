import 'dart:async';
import 'dart:convert';

import 'package:dart_mp_analytics/src/core/event_validator.dart';
import 'package:dart_mp_analytics/src/models/mp_analytics_options.dart';
import 'package:dart_mp_analytics/src/models/mp_analytics_user.dart';
import 'package:dart_mp_analytics/src/mp_analytics_client.dart';
import 'package:dart_mp_analytics/src/services/default_metadata_service.dart';
import 'package:dart_mp_analytics/src/services/metadata_service.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// {@template mp_analytics}
/// A class that allows tracking and logging of events for Google Analytics
/// using the Measurement Protocol.
///
/// The [options] parameter is required and must be an instance of correct
/// [MPAnalyticsOptions] subclass for the platform you are using on Google
/// Analytics.
///
/// The [metadataServiceList] parameter is optional and allows you to add custom
/// metadata to all events. By default, the [DefaultMetadataService] is used.
///
/// The [debugAnalytics] parameter is optional and defaults to false. When set
/// to true, the [MPAnalyticsClient] will send requests to the debug endpoint
/// instead of the normal endpoint. This is useful for debugging and testing
/// that events are being logged correctly.
///
/// The [enabled] parameter is optional and defaults to true. When set to false,
/// the [logEvent] method will not send any requests to the Google Analytics
/// Measurement Protocol.
///
/// The [verbose] parameter is optional and defaults to false. When set to true,
/// the [MPAnalytics] class will log all proccessing and requests to the console
/// {@endtemplate}
class MPAnalytics {
  /// {@macro mp_analytics}
  MPAnalytics({
    required this.options,
    this.metadataServiceList = const [DefaultMetadataService()],
    this.debugAnalytics = false,
    this.enabled = true,
    this.verbose = false,
    Logger? logger,
    MPAnalyticsClient? client,
  }) {
    _initialize(
      logger: logger,
      client: client,
    );
  }

  /// The options used to configure the [MPAnalytics] instance. This must be an
  /// instance of correct [MPAnalyticsOptions] subclass for the platform you are
  /// using on Google Analytics.
  final MPAnalyticsOptions options;

  /// A list of [MetadataService]s that will be used to add metadata to all
  /// events.
  final List<MetadataService> metadataServiceList;

  /// Whether or not to send requests to the debug endpoint. When set to true,
  /// the [MPAnalyticsClient] will send requests to the debug endpoint, to
  /// validate that events are being sent correctly.
  ///
  /// See https://developers.google.com/analytics/devguides/collection/protocol/ga4/validating-events
  final bool debugAnalytics;

  /// Whether or not to send requests to the Google Analytics Measurement
  final bool enabled;

  /// Whether or not to log debug messages to the console.
  final bool verbose;

  /// The user associated with this [MPAnalytics] instance.
  late final MPAnalyticsUser _user;

  /// The client used to send requests to the Google Analytics Measurement
  late final MPAnalyticsClient _client;

  /// The session ID for this [MPAnalytics] instance.
  String? _sessionId;

  late final Logger _logger;

  final EventValidator _validator = EventValidator();

  void _initialize({
    MPAnalyticsClient? client,
    Logger? logger,
  }) {
    _logger = logger ??
        Logger(
          printer: PrettyPrinter(
            methodCount: 0,
          ),
        );

    if (!enabled) {
      _verboseLog('MPAnalytics disabled, not initializing');
      return;
    }

    _verboseLog('Initializing MPAnalytics');
    _user = MPAnalyticsUser();
    _client = client ??
        MPAnalyticsClient(
          urlParameters: options.urlParameters,
        );
    _verboseLog('MPAnalytics initialized');
  }

  String _getOrCreateSessionId() {
    if (!enabled) {
      _verboseLog('MPAnalytics disabled, not creating session ID');
      return '';
    }
    if (_sessionId == null) {
      _sessionId = const Uuid().v4();
      _verboseLog('Created new session ID');
      Timer(const Duration(minutes: 30), () {
        _sessionId = null;
        _verboseLog('Session ID expired');
      });
    }
    return _sessionId!;
  }

  /// Sets the user ID for this [MPAnalytics] instance and all future events
  /// until [clearUserId] is called.
  ///
  /// See https://developers.google.com/analytics/devguides/collection/protocol/ga4/user-id
  void setUserId(String id) {
    if (!enabled) {
      _verboseLog('MPAnalytics disabled, not setting user ID: $id');
      return;
    }
    final isValid = _user.setId(id);

    if (!isValid) {
      _verboseLog('Invalid user ID, not setting user ID: $id');
      return;
    }

    _verboseLog('Set user ID: $id');
  }

  /// Clears the user ID for this [MPAnalytics] instance and all future events
  /// until [setUserId] is called.
  void clearUserId() {
    if (!enabled) {
      _verboseLog('MPAnalytics disabled, not clearing user ID');
      return;
    }
    _user.clearId();
    _verboseLog('Cleared user ID');
  }

  /// Sets the user property for this [MPAnalytics] instance and all future
  /// events until [removeUserProperty] is called with the same key.
  ///
  /// See https://developers.google.com/analytics/devguides/collection/protocol/ga4/user-properties
  void setUserProperty(String key, Object value) {
    if (!enabled) {
      _verboseLog(
        'MPAnalytics disabled, not setting user property: {$key : $value}',
      );
      return;
    }
    final isValid = _user.setProperty(key, value);

    if (!isValid) {
      _verboseLog(
        'Invalid user property, not setting user property: {$key : $value}',
      );
      return;
    }
    _verboseLog('Set user property: $key = $value');
  }

  /// Removes the user property for this [MPAnalytics] instance and all future
  /// events until [setUserProperty] is called with the same key.
  void removeUserProperty(String key) {
    if (!enabled) {
      _verboseLog('MPAnalytics disabled, not removing user property: $key');
      return;
    }
    _user.removeProperty(key);
    _verboseLog('Removed user property: $key');
  }

  /// Logs an event to Google Analytics using the Measurement Protocol.
  ///
  /// The [name] parameter is required and must be a valid event name.
  ///
  /// The [parameters] parameter is optional and allows you to add custom
  /// parameters to the event.
  ///
  /// See https://developers.google.com/analytics/devguides/collection/protocol/ga4/reference/events
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {
    if (!enabled) {
      _verboseLog('MPAnalytics disabled, not logging event: $name');
      return;
    }

    final (isValidEventName, isValidEventParameter) = (
      _validator.validateEventName(name),
      _validator.validateEventParameters(parameters),
    );

    if (!isValidEventName || !isValidEventParameter) {
      _verboseLog('Invalid event name or parameters, not logging event: $name');
      return;
    }

    final metadata = <String, Object?>{
      for (final service in metadataServiceList) ...await service.getMetadata(),
    };

    final eventData = <String, Object?>{
      'name': name,
      'params': {
        // Required parameters to show up in Firebase Analytics
        // https://developers.google.com/analytics/devguides/collection/protocol/ga4/sending-events?hl=pt-br&client_type=gtag#recommended_parameters_for_reports
        'engagement_time_msec': '100',
        'session_id': _getOrCreateSessionId(),
        ...metadata,
        ...parameters,
      },
    };

    final requestData = <String, Object?>{
      ...options.bodyParameters,
      ..._user.data,
      'events': [eventData],
    };

    final requestBody = jsonEncode(requestData);

    _verboseLog('Logging event: $name with parameters: $parameters');
    final response = await _client.logEvent(requestBody, debug: debugAnalytics);
    _verboseLog('Response: ${response?.body}');
  }

  void _verboseLog(String message) {
    if (verbose) {
      _logger.log(Level.info, message);
    }
  }
}
