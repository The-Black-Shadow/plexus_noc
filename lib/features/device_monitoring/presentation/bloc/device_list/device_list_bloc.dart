import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_list_event.dart';
part 'device_list_state.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  DeviceListBloc() : super(DeviceListInitial()) {
    on<DeviceListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
