part of 'alert_cubit.dart';

abstract class AlertState extends Equatable {
  @override
  List<Object> get props => [];
}

class AlertInitial extends AlertState {}

class AlertTriggered extends AlertState {
  final AlertEntity alert;
  final int timestampId;

  AlertTriggered({required this.alert})
    : timestampId = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [alert, timestampId];
}
