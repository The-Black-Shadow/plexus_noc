import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/repositories/device_repository.dart';

class GetAlertsStreamUseCase implements UseCase<Stream<AlertEntity>, NoParams> {
  final DeviceRepository repository;

  GetAlertsStreamUseCase(this.repository);

  @override
  Stream<AlertEntity> call(NoParams params) {
    return repository.getAlertsStream();
  }
}
