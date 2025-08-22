class DetectionResultEntity {
  final String requestId;
  final String originalFileName;
  final String mediaType;
  final String thumbnail;
  final String overallStatus;
  final String storageLocation;
  final Map<String, dynamic>? resultsSummary;
  final DateTime createdAt;

  DetectionResultEntity({
    required this.originalFileName,
    required this.requestId,
    required this.mediaType,
    required this.thumbnail,
    required this.overallStatus,
    required this.storageLocation,
    required this.createdAt,
    required this.resultsSummary,
  });
}
