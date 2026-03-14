import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/services/local_notification_service.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/get_alerts_stream.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  final GetAlertsStreamUseCase getAlertsStream;
  final LocalNotificationService notificationService; // <-- Add this
  StreamSubscription? _subscription;

  // Update constructor to require the service
  AlertCubit({required this.getAlertsStream, required this.notificationService})
    : super(AlertInitial());

  void startListening() {
    _subscription?.cancel();
    _subscription = getAlertsStream.call(NoParams()).listen((alert) {
      // Emit the state for the in-app popup dialog
      emit(AlertTriggered(alert: alert));

      // Fire the native push notification!
      notificationService.showNotification(
        // Use a unique ID based on time so multiple notifications don't overwrite each other
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: AppStrings.notificationTitle,
        body: alert.message,
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
