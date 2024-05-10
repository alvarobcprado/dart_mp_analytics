import 'package:dart_mp_analytics/src/core/reserved_events.dart';

/// A helper class to validate event names and parameters.
class EventValidator {
  /// Validates the given event name.
  ///
  /// Returns `true` if the event name is valid, `false` otherwise.
  ///
  /// Throws an assertion error if the event name is reserved, too long, or
  /// empty, or if it contains invalid characters.
  bool validateEventName(String eventName) {
    assert(
      !reservedEvents.contains(eventName),
      'Event name $eventName is reserved and cannot be used',
    );

    if (reservedEvents.contains(eventName)) return false;

    assert(
      eventName.length <= 40,
      'Event name $eventName is too long, must be 40 characters or less',
    );

    if (eventName.length > 40) return false;

    assert(
      eventName.isNotEmpty,
      'Event name $eventName cannot be empty',
    );

    if (eventName.isEmpty) return false;

    assert(
      RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(eventName),
      'Event name $eventName must start with a letter and only contain '
      'letters, numbers, and underscores',
    );

    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(eventName)) return false;

    return true;
  }

  /// Validates the given event parameters.
  ///
  /// Returns `true` if the event parameters are valid, `false` otherwise.
  ///
  /// Throws an assertion error if the event parameters contain more than 25
  /// entries, if any parameter key is too long, or if any parameter value is
  /// too long.
  bool validateEventParameters(Map<String, Object?> parameters) {
    assert(
      parameters.length <= 25,
      'Event parameters must be 25 or fewer',
    );

    if (parameters.length > 25) return false;

    assert(
      parameters.keys.every((key) => key.length <= 40),
      'Event parameter keys must be 40 characters or less',
    );

    if (!parameters.keys.every((key) => key.length <= 40)) return false;

    assert(
      parameters.values
          .whereType<String>()
          .every((value) => value.length <= 100),
      'Event parameter values must be 100 characters or less',
    );

    if (!parameters.values
        .whereType<String>()
        .every((value) => value.length <= 100)) return false;

    return true;
  }
}
