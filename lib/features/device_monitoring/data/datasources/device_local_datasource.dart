import 'package:plexus_noc/features/device_monitoring/data/models/device_model.dart';

abstract class DeviceLocalDataSource {
  /// Saves the latest list of devices to the local Hive database.
  Future<void> cacheDevices(List<DeviceModel> devices);

  /// Retrieves the last saved list of devices when offline.
  Future<List<DeviceModel>> getLastCachedDevices();
}
