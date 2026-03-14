import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/check_internet_connection.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/get_devices_stream.dart';

part 'device_list_event.dart';
part 'device_list_state.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  final GetDevicesStreamUseCase getDevicesStream;
  final CheckInternetConnectionUseCase checkInternetConnection;
  StreamSubscription<List<DeviceEntity>>? _deviceStreamSubscription;

  // Internal state tracking
  List<DeviceEntity> _allDevices = [];
  String _searchQuery = '';
  DeviceStatusFilter _currentFilter = DeviceStatusFilter.all;
  bool _isOffline = false;

  // Pagination State
  int _currentLimit = 10;
  static const int _paginationStep = 10;
  bool _isLoadingMore = false;

  DeviceListBloc({
    required this.getDevicesStream,
    required this.checkInternetConnection,
  }) : super(DeviceListLoading()) {
    on<StartDeviceListStreamEvent>(_onStartStream);
    on<_DevicesUpdatedEvent>(_onDevicesUpdated);
    on<SearchDevicesEvent>(_onSearchDevices);
    on<FilterDevicesEvent>(_onFilterDevices);
    on<RefreshDeviceListEvent>(_onRefreshList);
    on<LoadMoreDevicesEvent>(_onLoadMore);
  }

  Future<void> _onStartStream(
    StartDeviceListStreamEvent event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(DeviceListLoading());
    // Cancel any existing subscription before starting a new one
    _deviceStreamSubscription?.cancel();

    _isOffline = !(await checkInternetConnection(NoParams()));
    _currentLimit = _paginationStep; // Reset on fresh stream start

    // Listen to the stream and push data back into the Bloc as an event
    _deviceStreamSubscription = getDevicesStream
        .call(NoParams())
        .listen(
          (devices) => add(_DevicesUpdatedEvent(devices)),
          onError: (error) => emit(DeviceListError(message: error.toString())),
        );
  }

  void _onDevicesUpdated(
    _DevicesUpdatedEvent event,
    Emitter<DeviceListState> emit,
  ) {
    _allDevices = event.devices;
    emit(_buildLoadedState());
  }

  void _onSearchDevices(
    SearchDevicesEvent event,
    Emitter<DeviceListState> emit,
  ) {
    _searchQuery = event.query;
    _currentLimit = _paginationStep; // Reset limit on search
    _isLoadingMore = false;
    emit(_buildLoadedState());
  }

  void _onFilterDevices(
    FilterDevicesEvent event,
    Emitter<DeviceListState> emit,
  ) {
    _currentFilter = event.status;
    _currentLimit = _paginationStep; // Reset limit on filter change
    _isLoadingMore = false;
    emit(_buildLoadedState());
  }

  Future<void> _onRefreshList(
    RefreshDeviceListEvent event,
    Emitter<DeviceListState> emit,
  ) async {
    // For a mock stream, a pull-to-refresh simply recalculates and emits the current state.
    // Check internet connection
    _isOffline = !(await checkInternetConnection(NoParams()));

    if (!_isOffline) {
      // Re-subscribe if online to get live updates
      add(StartDeviceListStreamEvent());
    } else {
      // If still offline, re-emit loaded state with offline flag to show snackbar again if needed
      emit(_buildLoadedState());
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDevicesEvent event,
    Emitter<DeviceListState> emit,
  ) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    // Simulate network latency so the spinner plays out smoothly
    await Future.delayed(const Duration(milliseconds: 500));

    _currentLimit += _paginationStep;
    emit(_buildLoadedState());

    _isLoadingMore = false;
  }

  // The core calculation engine
  DeviceListLoaded _buildLoadedState() {
    List<DeviceEntity> filteredList = _allDevices;

    // Status Filter
    if (_currentFilter == DeviceStatusFilter.online) {
      filteredList = filteredList.where((d) => d.isOnline).toList();
    } else if (_currentFilter == DeviceStatusFilter.offline) {
      filteredList = filteredList.where((d) => !d.isOnline).toList();
    }

    // Search Query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredList = filteredList.where((d) {
        return d.name.toLowerCase().contains(query) ||
            d.ipAddress.contains(query) ||
            d.location.toLowerCase().contains(query);
      }).toList();
    }

    // Pagination Limit
    final bool hasReachedMax = filteredList.length <= _currentLimit;
    final paginatedList = filteredList.take(_currentLimit).toList();

    return DeviceListLoaded(
      devices: paginatedList,
      searchQuery: _searchQuery,
      filter: _currentFilter,
      isOffline: _isOffline,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  Future<void> close() {
    _deviceStreamSubscription?.cancel();
    return super.close();
  }
}
