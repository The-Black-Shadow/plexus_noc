part of 'device_list_bloc.dart';

sealed class DeviceListEvent extends Equatable {
  const DeviceListEvent();

  @override
  List<Object> get props => [];
}

class StartDeviceListStreamEvent extends DeviceListEvent {}

// Internal event used to push stream updates into the Bloc
class _DevicesUpdatedEvent extends DeviceListEvent {
  final List<DeviceEntity> devices;
  const _DevicesUpdatedEvent(this.devices);
}

class SearchDevicesEvent extends DeviceListEvent {
  final String query;
  const SearchDevicesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterDevicesEvent extends DeviceListEvent {
  final DeviceStatusFilter status;
  const FilterDevicesEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class RefreshDeviceListEvent extends DeviceListEvent {}

class LoadMoreDevicesEvent extends DeviceListEvent {}
