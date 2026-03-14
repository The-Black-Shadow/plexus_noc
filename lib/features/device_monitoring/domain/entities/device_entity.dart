enum DeviceStatus { online, offline }

class DeviceEntity {
  final String id;
  final String name;
  final String ipAddress;
  final String location;
  final double latitude;
  final double longitude;
  final DeviceStatus status;
  final DateTime lastPingTime;
  final double cpuUsage;
  final double memoryUsage;

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lastPingTime,
    required this.cpuUsage,
    required this.memoryUsage,
  });

  bool get isOnline => status == DeviceStatus.online;
}
