import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/get_devices_stream.dart';

part 'device_details_event.dart';
part 'device_details_state.dart';

class DeviceDetailsBloc extends Bloc<DeviceDetailsEvent, DeviceDetailsState> {
  final GetDevicesStreamUseCase getDevicesStream;
  StreamSubscription? _subscription;

  // Internal state for chart history
  double _timeCounter = 0;
  final int _maxDataPoints =
      15; // Shows the last ~75 seconds of data (15 ticks * 5 sec)
  final List<FlSpot> _cpuSpots = [];
  final List<FlSpot> _memorySpots = [];

  DeviceDetailsBloc({required this.getDevicesStream})
    : super(DeviceDetailsLoading()) {
    on<StartDeviceDetailsStream>(_onStartStream);
    on<_DeviceUpdateReceived>(_onDeviceUpdated);
  }

  void _onStartStream(
    StartDeviceDetailsStream event,
    Emitter<DeviceDetailsState> emit,
  ) {
    emit(DeviceDetailsLoading());
    _subscription?.cancel();

    _subscription = getDevicesStream.call(NoParams()).listen((devices) {
      try {
        // Find the specific device from the master stream
        final device = devices.firstWhere((d) => d.id == event.deviceId);
        add(_DeviceUpdateReceived(device));
      } catch (e) {
        emit(
          DeviceDetailsError("Device not found or went offline unexpectedly."),
        );
      }
    });
  }

  void _onDeviceUpdated(
    _DeviceUpdateReceived event,
    Emitter<DeviceDetailsState> emit,
  ) {
    final device = event.device;

    // Add new data points
    _cpuSpots.add(FlSpot(_timeCounter, device.cpuUsage));
    _memorySpots.add(FlSpot(_timeCounter, device.memoryUsage));

    // Keep the lists at a maximum of 15 points to make the chart slide left
    if (_cpuSpots.length > _maxDataPoints) {
      _cpuSpots.removeAt(0);
      _memorySpots.removeAt(0);
    }

    // Calculate dynamic X-axis bounds for the chart sliding effect
    final minX = _cpuSpots.first.x;
    final maxX =
        _cpuSpots.last.x + 1; // Add 1 so the line doesn't hit the absolute edge

    _timeCounter++;

    emit(
      DeviceDetailsLoaded(
        device: device,
        cpuHistory: List.from(
          _cpuSpots,
        ), // Create new instances so Equatable detects the change
        memoryHistory: List.from(_memorySpots),
        minX: minX,
        maxX: maxX,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
