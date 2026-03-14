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
  final LocalNotificationService notificationService;
  StreamSubscription? _subscription;

  final List<AlertEntity> _alertHistory = [];
  int _unreadCount = 0;

  AlertCubit({required this.getAlertsStream, required this.notificationService})
    : super(AlertInitial());

  List<AlertEntity> get alertHistory => List.unmodifiable(_alertHistory);
  int get unreadCount => _unreadCount;

  /// Returns a paginated slice of alert history.
  /// [page] is 0-indexed. Returns up to [pageSize] items.
  List<AlertEntity> getPage(int page, {int pageSize = 10}) {
    final start = page * pageSize;
    if (start >= _alertHistory.length) return [];
    final end = (start + pageSize).clamp(0, _alertHistory.length);
    return _alertHistory.sublist(start, end);
  }

  bool hasMorePages(int page, {int pageSize = 10}) {
    return (page + 1) * pageSize < _alertHistory.length;
  }

  void markAllRead() {
    _unreadCount = 0;
    emit(
      AlertHistoryUpdated(
        alerts: List.unmodifiable(_alertHistory),
        unreadCount: 0,
      ),
    );
  }

  void startListening() {
    _subscription?.cancel();
    _subscription = getAlertsStream.call(NoParams()).listen((alert) {
      // Store in history (newest first)
      _alertHistory.insert(0, alert);
      _unreadCount++;

      // Emit triggered state for the in-app popup dialog
      emit(AlertTriggered(alert: alert));

      // Emit history update so dashboard and notification pages rebuild
      emit(
        AlertHistoryUpdated(
          alerts: List.unmodifiable(_alertHistory),
          unreadCount: _unreadCount,
        ),
      );

      // Fire the native push notification
      notificationService.showNotification(
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
