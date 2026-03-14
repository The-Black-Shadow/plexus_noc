import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Ask for permission first
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(AppStrings.notificationAppIcon);

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          AppStrings.notificationChannelId,
          AppStrings.notificationChannelName,
          channelDescription: AppStrings.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          ticker: AppStrings.notificationTicker,
          color: AppColors.criticalRed,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
