part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalDevices;
  final int onlineDevices;
  final int offlineDevices;
  final int alerts;

  const DashboardLoaded({
    required this.totalDevices,
    required this.onlineDevices,
    required this.offlineDevices,
    required this.alerts,
  });

  // Equatable ensures the UI ONLY rebuilds if one of these exact numbers changes
  @override
  List<Object> get props => [
    totalDevices,
    onlineDevices,
    offlineDevices,
    alerts,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
