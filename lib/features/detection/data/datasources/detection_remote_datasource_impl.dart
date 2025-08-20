import 'package:true_sight/features/detection/data/datasources/detection_remote_data_source.dart';
import 'package:true_sight/features/detection/data/models/detection_result_model.dart';

class DetectionRemoteDatasourceImpl implements DetectionRemoteDataSource {
  @override
  Future<DetectionResultModel> analyzeVideo(String videoUrl) {
    // TODO: implement analyzeVideo
    throw UnimplementedError();
  }

  @override
  Future<String> uploadVideo(String filePath) {
    // TODO: implement uploadVideo
    throw UnimplementedError();
  }
  
}
