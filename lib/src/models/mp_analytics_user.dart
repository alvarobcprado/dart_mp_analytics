// ignore_for_file: use_setters_to_change_properties

import 'package:dart_mp_analytics/src/core/user_data_validator.dart';

///{@template mp_analytics_user}
/// A class that defines the user that will be added to all events.
///
/// This class is used to set the user id and user properties that will be added
/// to all events.
/// {@endtemplate}
class MPAnalyticsUser {
  /// {@macro mp_analytics_user}
  MPAnalyticsUser();

  String _id = '';
  final Map<String, Object?> _properties = {};
  final UserDataValidator _validator = UserDataValidator();

  /// Returns a [Map] of the user id and user properties that will be added to
  /// all events.
  Map<String, Object?> get data {
    return {
      if (_id.isNotEmpty) 'user_id': _id,
      if (_properties.isNotEmpty) 'user_properties': _properties,
    };
  }

  /// Sets the user id that will be added to all events.
  bool setId(String id) {
    final isValid = _validator.validateUserId(id);

    if (isValid) _id = id;

    return isValid;
  }

  /// Removes the current user id if one exists.
  void clearId() {
    _id = '';
  }

  /// Sets a user property that will be added to all events.
  bool setProperty(String key, Object value) {
    final isValid = _validator.canAddUserProperty(_properties) &&
        _validator.validateUserProperty(MapEntry(key, value));

    if (isValid) _properties[key] = {'value': value};

    return isValid;
  }

  /// Removes a user property if one exists.
  void removeProperty(String key) {
    _properties.remove(key);
  }
}
