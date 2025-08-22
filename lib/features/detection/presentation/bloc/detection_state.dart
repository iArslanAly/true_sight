part of 'detection_bloc.dart';

class DetectionState extends Equatable {
  const DetectionState({
    this.status = const ApiInitial(),
    this.detectionResult,
    this.isPlaying = false,
    this.uploadProgress = 0,
  });

  final ApiStatus status;
  final DetectionResultEntity? detectionResult;
  final bool isPlaying;
  final int uploadProgress;

  DetectionState copyWith({
    ApiStatus? status,
    DetectionResultEntity? detectionResult,
    bool? isPlaying,
    int? uploadProgress,
  }) {
    return DetectionState(
      status: status ?? this.status,
      detectionResult: detectionResult ?? this.detectionResult,
      isPlaying: isPlaying ?? this.isPlaying,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detectionResult,
    isPlaying,
    uploadProgress,
  ];
}
