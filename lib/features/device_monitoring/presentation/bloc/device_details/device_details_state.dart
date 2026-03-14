part of 'device_details_bloc.dart';

sealed class DeviceDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeviceDetailsLoading extends DeviceDetailsState {}

class DeviceDetailsLoaded extends DeviceDetailsState {
  final DeviceEntity device;
  final List<FlSpot> cpuHistory;
  final List<FlSpot> memoryHistory;
  final double minX;
  final double maxX;

  DeviceDetailsLoaded({
    required this.device,
    required this.cpuHistory,
    required this.memoryHistory,
    required this.minX,
    required this.maxX,
  });

  @override
  List<Object> get props => [device, cpuHistory, memoryHistory, minX, maxX];
}

class DeviceDetailsError extends DeviceDetailsState {
  final String message;
  DeviceDetailsError(this.message);
}