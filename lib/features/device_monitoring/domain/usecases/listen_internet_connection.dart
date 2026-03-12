import 'package:plexus_noc/core/network/network_info.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';

class ListenInternetConnectionUseCase
    implements UseCase<Stream<bool>, NoParams> {
  final NetworkInfo networkInfo;

  ListenInternetConnectionUseCase(this.networkInfo);

  @override
  Stream<bool> call(NoParams params) {
    return networkInfo.onConnectedChange;
  }
}
