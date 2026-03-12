import 'package:plexus_noc/core/network/network_info.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';

class CheckInternetConnectionUseCase implements UseCase<Future<bool>, NoParams> {
  final NetworkInfo networkInfo;

  CheckInternetConnectionUseCase(this.networkInfo);

  @override
  Future<bool> call(NoParams params) {
    return networkInfo.isConnected;
  }
}
