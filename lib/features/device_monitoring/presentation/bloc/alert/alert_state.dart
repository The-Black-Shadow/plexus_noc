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

class AlertHistoryUpdated extends AlertState {
  final List<AlertEntity> alerts;
  final int unreadCount;
  final int timestampId;

  AlertHistoryUpdated({
    required this.alerts,
    required this.unreadCount,
  }) : timestampId = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [alerts, unreadCount, timestampId];
}
