import 'dart:async';
import 'package:plexus_noc/core/network/network_info.dart';
import 'package:plexus_noc/features/device_monitoring/data/datasources/device_local_datasource.dart';
import 'package:plexus_noc/features/device_monitoring/data/datasources/device_remote_datasource.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;
  final DeviceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Stream<List<DeviceEntity>> getDevicesStream() async* {
    if (await networkInfo.isConnected) {
      // 1. OFFLINE SUPPORT[cite: 4, 7]: Immediately yield cached data so the UI loads instantly.
      try {
        final cachedDevices = await localDataSource.getLastCachedDevices();
        yield cachedDevices;
      } catch (_) {
        // If there is no cache (e.g., first app launch), simply proceed to the remote stream.
      }
    } else {
      // Offline: Yield cached data.
      try {
        final cachedDevices = await localDataSource.getLastCachedDevices();
        yield cachedDevices;
      } catch (_) {
        yield <DeviceEntity>[]; // If no cache and offline, yield empty list.
      }
    }

    // 2. Yield the live remote stream continuously.
    // Use an await-for loop to dynamically block the stream packets when the connection drops mid-session.
    await for (final deviceModels
        in remoteDataSource.getRealtimeDevicesStream()) {
      if (await networkInfo.isConnected) {
        // Save the fresh data to Hive silently in the background
        localDataSource.cacheDevices(deviceModels);
        // Safely return the array
        yield deviceModels;
      } else {
        // Do not yield new data. Keep the UI at whatever the last cached state is,
        // or whatever state the BLoC is currently holding.
      }
    }
  }

  @override
  Stream<AlertEntity> getAlertsStream() async* {
    await for (final alert in remoteDataSource.getRealtimeAlertsStream()) {
      if (await networkInfo.isConnected) {
        yield alert;
      }
    }
  }
}
