part of 'device_details_bloc.dart';

sealed class DeviceDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartDeviceDetailsStream extends DeviceDetailsEvent {
  final String deviceId;
  StartDeviceDetailsStream(this.deviceId);
}

class _DeviceUpdateReceived extends DeviceDetailsEvent {
  final DeviceEntity device;
  _DeviceUpdateReceived(this.device);
}
