import 'package:true_sight/features/detection/domain/entities/detection_result.dart';

class DetectionResultModel extends DetectionResult {
  DetectionResultModel({
    required super.originalFileName,
    required super.requestId,
    required super.mediaType,
    required super.thumbnail,
    required super.overallStatus,
    required super.storageLocation,
    required super.createdAt,
    required super.resultsSummary,
  });

  factory DetectionResultModel.fromJson(Map<String, dynamic> json) {
    return DetectionResultModel(
      originalFileName: json['originalFileName'],
      requestId: json['requestId'],
      mediaType: json['mediaType'],
      thumbnail: json['thumbnail'],
      overallStatus: json['overallStatus'],
      storageLocation: json['storageLocation'],
      createdAt: DateTime.parse(json['createdAt']),
      resultsSummary: json['resultsSummary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalFileName': originalFileName,
      'requestId': requestId,
      'mediaType': mediaType,
      'thumbnail': thumbnail,
      'overallStatus': overallStatus,
      'storageLocation': storageLocation,
      'createdAt': createdAt.toIso8601String(),
      'resultsSummary': resultsSummary,
    };
  }
}
