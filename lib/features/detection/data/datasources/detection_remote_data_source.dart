import 'package:true_sight/features/detection/data/models/detection_result_model.dart';

abstract class DetectionRemoteDataSource {
  Future<String> uploadVideo(String filePath); // Cloudinary
  Future<DetectionResultModel> analyzeVideo(
    String videoUrl,
  ); // Reality Defender
}
