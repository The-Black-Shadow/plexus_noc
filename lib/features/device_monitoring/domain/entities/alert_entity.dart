import 'package:equatable/equatable.dart';

class AlertEntity extends Equatable {
  final String deviceId;
  final String deviceName;
  final String alertType;
  final String message;
  final DateTime timestamp;

  const AlertEntity({
    required this.deviceId,
    required this.deviceName,
    required this.alertType,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object> get props => [deviceId, deviceName, alertType, message, timestamp];
}
