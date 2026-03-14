part of 'device_list_bloc.dart';

// The enum to handle the required filtering
enum DeviceStatusFilter { all, online, offline }

sealed class DeviceListState extends Equatable {
  const DeviceListState();

  @override
  List<Object> get props => [];
}

class DeviceListLoading extends DeviceListState {}

class DeviceListLoaded extends DeviceListState {
  final List<DeviceEntity> devices;
  final String searchQuery;
  final DeviceStatusFilter filter;
  final bool isOffline;
  final bool hasReachedMax;

  const DeviceListLoaded({
    required this.devices,
    required this.searchQuery,
    required this.filter,
    this.isOffline = false,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [
    devices,
    searchQuery,
    filter,
    isOffline,
    hasReachedMax,
  ];
}

class DeviceListError extends DeviceListState {
  final String message;

  const DeviceListError({required this.message});

  @override
  List<Object> get props => [message];
}
