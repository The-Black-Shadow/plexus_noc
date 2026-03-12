import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/check_internet_connection.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/listen_internet_connection.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final CheckInternetConnectionUseCase checkInternetConnection;
  final ListenInternetConnectionUseCase listenInternetConnection;
  StreamSubscription<bool>? _networkSubscription;

  NetworkCubit({
    required this.checkInternetConnection,
    required this.listenInternetConnection,
  }) : super(NetworkInitial()) {
    _initNetworkCheck();
  }

  Future<void> _initNetworkCheck() async {
    // Check initial state
    final isOnline = await checkInternetConnection(NoParams());
    if (isOnline) {
      emit(NetworkOnline());
    } else {
      emit(NetworkOffline());
    }

    // Listen to changes
    _networkSubscription = listenInternetConnection(NoParams()).listen((
      isConnected,
    ) {
      if (isConnected) {
        emit(NetworkOnline());
      } else {
        emit(NetworkOffline());
      }
    });
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    return super.close();
  }
}
