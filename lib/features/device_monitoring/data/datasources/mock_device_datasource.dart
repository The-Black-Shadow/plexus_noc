import 'dart:async';
import 'dart:math';
import 'package:plexus_noc/features/device_monitoring/data/models/device_model.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';

import 'device_remote_datasource.dart';

class MockDeviceDataSource implements DeviceRemoteDataSource {
  final Random _random = Random();

  // Broadcast streams allow multiple Blocs (Dashboard, List, Details) to listen simultaneously.
  final StreamController<List<DeviceModel>> _deviceStreamController =
      StreamController<List<DeviceModel>>.broadcast();
  final StreamController<AlertEntity> _alertStreamController =
      StreamController<AlertEntity>.broadcast();

  Timer? _pollingTimer;
  Timer? _telemetryTimer;
  List<DeviceModel> _cachedDevices = [];

  MockDeviceDataSource() {
    _cachedDevices = _generateBaseMockData();
    // Add initial data to the stream immediately upon instantiation
    _deviceStreamController.add(_cachedDevices);
    _startSimulationTimers();
  }

  void dispose() {
    _pollingTimer?.cancel();
    _telemetryTimer?.cancel();
    _deviceStreamController.close();
    _alertStreamController.close();
  }

  @override
  Stream<List<DeviceModel>> getRealtimeDevicesStream() =>
      _deviceStreamController.stream;

  @override
  Stream<AlertEntity> getRealtimeAlertsStream() =>
      _alertStreamController.stream;

  // --- PRIVATE SIMULATION LOGIC ---

  List<DeviceModel> _generateBaseMockData() {
    // Base coordinates clustered around Dhaka for realistic map testing
    const double baseLat = 23.8103;
    const double baseLng = 90.4125;

    return List.generate(100, (index) {
      final id = 'dev_${(index + 1).toString().padLeft(3, '0')}';

      // Slight random offset for map markers
      final latOffset = (_random.nextDouble() - 0.5) * 0.15;
      final lngOffset = (_random.nextDouble() - 0.5) * 0.15;

      return DeviceModel(
        id: id,
        name: index == 0
            ? 'Core Router 01'
            : 'Switch Alpha-${index.toString().padLeft(2, '0')}',
        ipAddress: '10.0.0.${10 + index}',
        location: index % 3 == 0
            ? 'Data Center A'
            : 'Branch Office ${index % 3}',
        latitude: baseLat + latOffset,
        longitude: baseLng + lngOffset,
        status: index % 7 == 0 ? DeviceStatus.offline : DeviceStatus.online,
        lastPingTime: DateTime.now().subtract(
          Duration(seconds: _random.nextInt(60)),
        ),
        cpuUsage: _random.nextDouble() * 40 + 20, // 20% - 60% base
        memoryUsage: _random.nextDouble() * 50 + 30, // 30% - 80% base
      );
    });
  }

  void _startSimulationTimers() {
    // --- TIMER 1: CPU & Memory telemetry every 1 second ---
    _telemetryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final updatedDevices = List<DeviceModel>.from(_cachedDevices);

      for (int i = 0; i < updatedDevices.length; i++) {
        final device = updatedDevices[i];

        if (device.status == DeviceStatus.online) {
          // Generate dramatic random jumps for visually interesting charts
          final newCpu = _random.nextDouble() * 100;
          final newMem = _random.nextDouble() * 100;

          // Blend: 40% old value + 60% new random → creates big visible swings
          final blendedCpu = device.cpuUsage * 0.4 + newCpu * 0.6;
          final blendedMem = device.memoryUsage * 0.4 + newMem * 0.6;

          updatedDevices[i] = device.copyWith(
            cpuUsage: max(0.0, min(100.0, blendedCpu)),
            memoryUsage: max(0.0, min(100.0, blendedMem)),
            lastPingTime: DateTime.now(),
          );
        } else {
          // Offline devices should always show 0 usage
          updatedDevices[i] = device.copyWith(cpuUsage: 0.0, memoryUsage: 0.0);
        }
      }

      _cachedDevices = updatedDevices;
      _deviceStreamController.add(_cachedDevices);
    });

    // --- TIMER 2: Online/Offline status toggle every 10 seconds ---
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final updatedDevices = List<DeviceModel>.from(_cachedDevices);

      // Pick a few random devices to toggle status
      final int toggleCount = _random.nextInt(3) + 1; // 1–3 devices
      for (int t = 0; t < toggleCount; t++) {
        final index = _random.nextInt(updatedDevices.length);
        final device = updatedDevices[index];

        final newStatus = device.status == DeviceStatus.online
            ? DeviceStatus.offline
            : DeviceStatus.online;

        // Fire alert when a device goes offline
        if (newStatus == DeviceStatus.offline) {
          _alertStreamController.add(
            AlertEntity(
              deviceId: device.id,
              deviceName: device.name,
              alertType: 'Device Offline',
              message: '${device.name} is offline',
              timestamp: DateTime.now(),
            ),
          );

          updatedDevices[index] = device.copyWith(
            status: newStatus,
            cpuUsage: 0.0,
            memoryUsage: 0.0,
          );
        } else {
          updatedDevices[index] = device.copyWith(
            status: newStatus,
            cpuUsage: _random.nextDouble() * 40 + 20,
            memoryUsage: _random.nextDouble() * 50 + 30,
            lastPingTime: DateTime.now(),
          );
        }
      }

      _cachedDevices = updatedDevices;
      _deviceStreamController.add(_cachedDevices);
    });
  }
}
