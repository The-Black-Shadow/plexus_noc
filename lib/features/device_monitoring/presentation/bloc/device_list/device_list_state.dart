part of 'device_list_bloc.dart';

sealed class DeviceListState extends Equatable {
  const DeviceListState();
  
  @override
  List<Object> get props => [];
}

final class DeviceListInitial extends DeviceListState {}
