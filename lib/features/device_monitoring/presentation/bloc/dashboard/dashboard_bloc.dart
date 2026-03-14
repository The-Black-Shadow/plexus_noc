import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/get_devices_stream.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDevicesStreamUseCase getDevicesStream;

  DashboardBloc({required this.getDevicesStream}) : super(DashboardLoading()) {
    on<StartDashboardStreamEvent>(_onStartDashboardStream);
  }

  Future<void> _onStartDashboardStream(
    StartDashboardStreamEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    await emit.forEach(
      getDevicesStream.call(NoParams()),
      onData: (devices) {
        final int total = devices.length;
        final int online = devices.where((d) => d.isOnline).length;
        final int offline = total - online;

        // Count offline devices PLUS any online device struggling with >= 90% usage
        final int alerts = devices.where((d) {
          final isOffline = !d.isOnline;
          final isHighCpu = d.cpuUsage >= 90.0;
          final isHighMem = d.memoryUsage >= 90.0;

          return isOffline || isHighCpu || isHighMem;
        }).length;

        return DashboardLoaded(
          totalDevices: total,
          onlineDevices: online,
          offlineDevices: offline,
          alerts: alerts,
        );
      },
      onError: (error, stackTrace) => DashboardError(message: error.toString()),
    );
  }
}
