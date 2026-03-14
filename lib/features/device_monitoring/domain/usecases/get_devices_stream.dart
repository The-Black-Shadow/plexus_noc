import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/repositories/device_repository.dart';

class GetDevicesStreamUseCase
    implements UseCase<Stream<List<DeviceEntity>>, NoParams> {
  final DeviceRepository repository;

  GetDevicesStreamUseCase(this.repository);

  @override
  Stream<List<DeviceEntity>> call(NoParams params) {
    return repository.getDevicesStream();
  }
}
