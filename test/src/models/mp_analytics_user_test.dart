import 'package:dart_mp_analytics/src/models/mp_analytics_user.dart';
import 'package:test/test.dart';

void main() {
  group('MPAnalyticsUser', () {
    late MPAnalyticsUser analyticsUser;

    setUp(() {
      analyticsUser = MPAnalyticsUser();
    });

    test('data should return correct user data when id and properties are set',
        () {
      analyticsUser
        ..setId('user123')
        ..setProperty('name', 'John Doe')
        ..setProperty('age', 30);

      final userData = analyticsUser.data;

      expect(userData.containsKey('user_id'), isTrue);
      expect(userData['user_id'], 'user123');
      expect(userData.containsKey('user_properties'), isTrue);
      final userProperties =
          userData['user_properties'] as Map<String, dynamic>?;

      expect(userProperties?.containsKey('name'), isTrue);
      expect(userProperties?.containsKey('age'), isTrue);
    });

    test('data should return correct user data when only id is set', () {
      analyticsUser.setId('user123');

      final userData = analyticsUser.data;

      expect(userData.containsKey('user_id'), isTrue);
      expect(userData.containsKey('user_properties'), isFalse);
    });

    test('data should return correct user data when only properties are set',
        () {
      analyticsUser
        ..setProperty('name', 'John Doe')
        ..setProperty('age', 30);

      final userData = analyticsUser.data;

      expect(userData.containsKey('user_id'), isFalse);
      expect(userData.containsKey('user_properties'), isTrue);
      final userProperties =
          userData['user_properties'] as Map<String, dynamic>?;
      expect(userProperties?.containsKey('name'), isTrue);
      expect(userProperties?.containsKey('age'), isTrue);
    });

    test('data should return empty map when neither id nor properties are set',
        () {
      final userData = analyticsUser.data;

      expect(userData.isEmpty, isTrue);
    });

    test('clearId should clear the user id', () {
      analyticsUser.setId('user123');
      expect(analyticsUser.data.containsKey('user_id'), isTrue);
      analyticsUser.clearId();
      expect(analyticsUser.data.containsKey('user_id'), isFalse);
    });

    test('removeProperty should remove the specified user property', () {
      analyticsUser
        ..setProperty('name', 'John Doe')
        ..setProperty('age', 30);

      final userData = analyticsUser.data;

      expect(userData.containsKey('user_properties'), isTrue);
      final userProperties =
          userData['user_properties'] as Map<String, dynamic>?;
      expect(userProperties?.containsKey('name'), isTrue);
      expect(userProperties?.containsKey('age'), isTrue);
      analyticsUser.removeProperty('name');
      final updatedUserData = analyticsUser.data;
      final updatedUserProperties =
          updatedUserData['user_properties'] as Map<String, dynamic>?;
      expect(updatedUserProperties?.containsKey('name'), isFalse);
      expect(updatedUserProperties?.containsKey('age'), isTrue);
    });
  });
}
