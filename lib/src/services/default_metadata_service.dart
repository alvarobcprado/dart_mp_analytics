import 'package:dart_mp_analytics/src/services/metadata_service.dart';
import 'package:platform_info/platform_info.dart';

/// {@template default_metadata_service}
/// A [MetadataService] that adds the locale, operating system, and operating
/// system version to all events.
/// {@endtemplate}
class DefaultMetadataService extends MetadataService {
  /// {@macro default_metadata_service}
  const DefaultMetadataService();

  @override
  Future<Map<String, Object>> getMetadata() async {
    final metadata = <String, Object>{};

    final values = await Future.wait([
      _getLocale(),
      _getOS(),
      _getOSVersion(),
    ]);

    metadata['locale'] = values[0];
    metadata['os'] = values[1];
    metadata['os_version'] = values[2];

    return metadata;
  }

  Future<String> _getLocale() async {
    final platformInfo = Platform.instance;

    return platformInfo.locale;
  }

  Future<String> _getOS() async {
    final platformInfo = Platform.instance;

    return platformInfo.operatingSystem.name;
  }

  Future<String> _getOSVersion() async {
    final platformInfo = Platform.instance;

    return platformInfo.version;
  }
}
