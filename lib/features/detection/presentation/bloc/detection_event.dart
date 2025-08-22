part of 'detection_bloc.dart';

sealed class DetectionEvent extends Equatable {
  const DetectionEvent();

  @override
  List<Object> get props => [];
}

class StartDetectionEvent extends DetectionEvent {
  final File file;

  const StartDetectionEvent(this.file);

  @override
  List<Object> get props => [file];
}

class StopDetectionEvent extends DetectionEvent {
  const StopDetectionEvent();

  @override
  List<Object> get props => [];
}

class RestoreHistoryEvent extends DetectionEvent {
  const RestoreHistoryEvent();

  @override
  List<Object> get props => [];
}

class DetectionProgressUpdatedEvent extends DetectionEvent {
  final int sent;
  final int total;

  const DetectionProgressUpdatedEvent(this.sent, this.total);

  @override
  List<Object> get props => [sent, total];
}
