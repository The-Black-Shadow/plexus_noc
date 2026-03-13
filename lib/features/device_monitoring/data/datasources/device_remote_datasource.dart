import 'package:plexus_noc/features/device_monitoring/data/models/device_model.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';

abstract class DeviceRemoteDataSource {
  /// Emits a continuously updating list of devices.
  Stream<List<DeviceModel>> getRealtimeDevicesStream();

  /// Emits a single alert whenever a device drops offline.
  Stream<AlertEntity> getRealtimeAlertsStream();
}
