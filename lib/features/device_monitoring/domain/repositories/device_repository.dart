import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';

abstract class DeviceRepository {
  /// Returns a stream of device updates. Handles local caching internally.
  Stream<List<DeviceEntity>> getDevicesStream();

  /// Returns a stream of real-time alerts.
  Stream<AlertEntity> getAlertsStream();
}
