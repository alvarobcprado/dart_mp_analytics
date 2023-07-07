import 'package:dart_mp_analytics/src/services/default_metadata_service.dart';
import 'package:platform_info/platform_info.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultMetadataService', () {
    late DefaultMetadataService metadataService;
    late FakePlatform mockPlatform;

    setUp(() {
      mockPlatform = FakePlatform(
        operatingSystem: OperatingSystem.iOS,
        version: '14.5.1',
        locale: 'en_US',
      );
      metadataService = DefaultMetadataService(
        platformInfo: mockPlatform,
      );
    });

    test('getMetadata should return correct metadata', () async {
      mockPlatform.when(
        iOS: () => true,
        orElse: () => false,
      );

      final metadata = await metadataService.getMetadata();

      expect(metadata['locale'], 'en_US');
      expect(metadata['os'], 'iOS');
      expect(metadata['os_version'], '14.5.1');
    });
  });
}
