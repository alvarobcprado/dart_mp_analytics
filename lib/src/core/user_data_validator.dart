/// A helper class to validate user analytics data.
class UserDataValidator {
  /// Returns `true` if the user properties can be added, `false` otherwise.
  bool canAddUserProperty(Map<String, Object?> userProperties) {
    assert(
      userProperties.length < 25,
      'User properties length must be less than 25',
    );

    return userProperties.length < 25;
  }

  /// Validates the given user property.
  ///
  /// Returns `true` if the user properties are valid, `false` otherwise.
  ///
  /// Throws an assertion error if the user property key or value is too long.
  bool validateUserProperty(MapEntry<String, Object> userProperty) {
    final key = userProperty.key;
    final value = userProperty.value;

    assert(
      key.length <= 24,
      'User property key $key is too long, must be 24 characters or less',
    );

    assert(
      value.toString().length <= 36,
      'User property value $value is too long, must be 36 characters or less',
    );

    if (key.length > 24 || value.toString().length > 36) return false;

    return true;
  }

  /// Validates the given user ID.
  ///
  /// Returns `true` if the user ID is valid, `false` otherwise.
  ///
  /// Throws an assertion error if the user ID is too long.
  bool validateUserId(String id) {
    assert(
      id.length <= 256,
      'User ID $id is too long, must be 256 characters or less',
    );

    if (id.length > 256) return false;

    return true;
  }
}
