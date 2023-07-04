// ignore_for_file: use_setters_to_change_properties

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

  /// Returns a [Map] of the user id and user properties that will be added to
  /// all events.
  Map<String, Object?> get data {
    return {
      if (_id.isNotEmpty) 'user_id': _id,
      if (_properties.isNotEmpty) 'user_properties': _properties,
    };
  }

  /// Sets the user id that will be added to all events.
  void setId(String id) {
    _id = id;
  }

  /// Removes the current user id if one exists.
  void clearId() {
    _id = '';
  }

  /// Sets a user property that will be added to all events.
  void setProperty(String key, Object value) {
    _properties[key] = {
      'value': value,
    };
  }

  /// Removes a user property if one exists.
  void removeProperty(String key) {
    _properties.remove(key);
  }
}
