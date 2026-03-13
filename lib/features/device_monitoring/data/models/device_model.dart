import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.name,
    required super.ipAddress,
    required super.location,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.lastPingTime,
    required super.cpuUsage,
    required super.memoryUsage,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['deviceName'] as String,
      ipAddress: json['ipAddress'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] == 'Online'
          ? DeviceStatus.online
          : DeviceStatus.offline,
      lastPingTime: DateTime.parse(json['lastPingTime'] as String),
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      memoryUsage: (json['memoryUsage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceName': name,
      'ipAddress': ipAddress,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'status': status == DeviceStatus.online ? 'Online' : 'Offline',
      'lastPingTime': lastPingTime.toIso8601String(),
      'cpuUsage': cpuUsage,
      'memoryUsage': memoryUsage,
    };
  }

  // Used by the MockDataSource to easily update values during periodic polling
  DeviceModel copyWith({
    String? id,
    String? name,
    String? ipAddress,
    String? location,
    double? latitude,
    double? longitude,
    DeviceStatus? status,
    DateTime? lastPingTime,
    double? cpuUsage,
    double? memoryUsage,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      lastPingTime: lastPingTime ?? this.lastPingTime,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      memoryUsage: memoryUsage ?? this.memoryUsage,
    );
  }
}
