/// {@template metadata_service}
/// An abstract class that defines the interface for metadata services.
/// Metadata services are used to add metadata to all events.
/// {@endtemplate}
abstract class MetadataService {
  /// {@macro metadata_service}
  const MetadataService();

  /// Returns a [Future] that resolves to a [Map] of metadata that will be added
  /// to all events.
  Future<Map<String, Object>> getMetadata();
}
