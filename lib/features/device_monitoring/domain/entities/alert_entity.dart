class AlertEntity {
  final String deviceId;
  final String message;
  final DateTime timestamp;

  const AlertEntity({
    required this.deviceId,
    required this.message,
    required this.timestamp,
  });
}
