import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:plexus_noc/features/device_monitoring/data/models/device_model.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';

import 'device_remote_datasource.dart';

/// Thin main-thread proxy that delegates all heavy simulation work
/// to a background [Isolate] and forwards decoded results to broadcast streams.
class MockDeviceDataSource implements DeviceRemoteDataSource {
  final StreamController<List<DeviceModel>> _deviceStreamController =
      StreamController<List<DeviceModel>>.broadcast();
  final StreamController<AlertEntity> _alertStreamController =
      StreamController<AlertEntity>.broadcast();

  Isolate? _isolate;
  ReceivePort? _receivePort;

  MockDeviceDataSource() {
    _spawnIsolate();
  }

  Future<void> _spawnIsolate() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _isolateEntryPoint,
      _receivePort!.sendPort,
    );

    _receivePort!.listen((message) {
      if (message is! Map<String, dynamic>) return;

      final type = message['type'] as String;

      switch (type) {
        case 'devices':
          final rawList = message['data'] as List<dynamic>;
          final devices = rawList
              .cast<Map<String, dynamic>>()
              .map(DeviceModel.fromJson)
              .toList();
          _deviceStreamController.add(devices);

        case 'alert':
          final data = message['data'] as Map<String, dynamic>;
          _alertStreamController.add(
            AlertEntity(
              deviceId: data['deviceId'] as String,
              deviceName: data['deviceName'] as String,
              alertType: data['alertType'] as String,
              message: data['message'] as String,
              timestamp: DateTime.parse(data['timestamp'] as String),
            ),
          );
      }
    });
  }

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
    _deviceStreamController.close();
    _alertStreamController.close();
  }

  @override
  Stream<List<DeviceModel>> getRealtimeDevicesStream() =>
      _deviceStreamController.stream;

  @override
  Stream<AlertEntity> getRealtimeAlertsStream() =>
      _alertStreamController.stream;
}

// ─────────────────────────────────────────────────────────────────────────────
// ISOLATE ENTRY POINT — runs entirely on a background thread.
// All Random, Timer, data generation and mutation live here.
// ─────────────────────────────────────────────────────────────────────────────

void _isolateEntryPoint(SendPort sendPort) {
  final random = Random();

  // ── Generate initial devices ──────────────────────────────────────────────
  const double baseLat = 23.8103;
  const double baseLng = 90.4125;

  List<Map<String, dynamic>> devices = List.generate(100, (index) {
    final id = 'dev_${(index + 1).toString().padLeft(3, '0')}';
    final latOffset = (random.nextDouble() - 0.5) * 0.15;
    final lngOffset = (random.nextDouble() - 0.5) * 0.15;

    return {
      'id': id,
      'deviceName': index == 0
          ? 'Core Router 01'
          : 'Switch Alpha-${index.toString().padLeft(2, '0')}',
      'ipAddress': '10.0.0.${10 + index}',
      'location':
          index % 3 == 0 ? 'Data Center A' : 'Branch Office ${index % 3}',
      'latitude': baseLat + latOffset,
      'longitude': baseLng + lngOffset,
      'status': index % 7 == 0 ? 'Offline' : 'Online',
      'lastPingTime': DateTime.now()
          .subtract(Duration(seconds: random.nextInt(60)))
          .toIso8601String(),
      'cpuUsage': random.nextDouble() * 40 + 20,
      'memoryUsage': random.nextDouble() * 50 + 30,
    };
  });

  // Send initial snapshot
  sendPort.send({'type': 'devices', 'data': devices});

  // ── TIMER 1: CPU & Memory telemetry every 1 second ──────────────────────
  Timer.periodic(const Duration(seconds: 1), (_) {
    for (int i = 0; i < devices.length; i++) {
      final device = devices[i];
      final isOnline = device['status'] == 'Online';

      if (isOnline) {
        final oldCpu = (device['cpuUsage'] as num).toDouble();
        final oldMem = (device['memoryUsage'] as num).toDouble();

        final newCpu = random.nextDouble() * 100;
        final newMem = random.nextDouble() * 100;

        final blendedCpu = (oldCpu * 0.4 + newCpu * 0.6).clamp(0.0, 100.0);
        final blendedMem = (oldMem * 0.4 + newMem * 0.6).clamp(0.0, 100.0);

        devices[i] = {
          ...device,
          'cpuUsage': blendedCpu,
          'memoryUsage': blendedMem,
          'lastPingTime': DateTime.now().toIso8601String(),
        };
      } else {
        devices[i] = {
          ...device,
          'cpuUsage': 0.0,
          'memoryUsage': 0.0,
        };
      }
    }

    sendPort.send({'type': 'devices', 'data': devices});
  });

  // ── TIMER 2: Online/Offline status toggle every 10 seconds ──────────────
  Timer.periodic(const Duration(seconds: 10), (_) {
    final toggleCount = random.nextInt(3) + 1;

    for (int t = 0; t < toggleCount; t++) {
      final index = random.nextInt(devices.length);
      final device = devices[index];

      final wasOnline = device['status'] == 'Online';
      final newStatus = wasOnline ? 'Offline' : 'Online';

      if (wasOnline) {
        // Going offline → fire alert
        sendPort.send({
          'type': 'alert',
          'data': {
            'deviceId': device['id'],
            'deviceName': device['deviceName'],
            'alertType': 'Device Offline',
            'message': '${device['deviceName']} is offline',
            'timestamp': DateTime.now().toIso8601String(),
          },
        });

        devices[index] = {
          ...device,
          'status': newStatus,
          'cpuUsage': 0.0,
          'memoryUsage': 0.0,
        };
      } else {
        devices[index] = {
          ...device,
          'status': newStatus,
          'cpuUsage': random.nextDouble() * 40 + 20,
          'memoryUsage': random.nextDouble() * 50 + 30,
          'lastPingTime': DateTime.now().toIso8601String(),
        };
      }
    }

    sendPort.send({'type': 'devices', 'data': devices});
  });
}
