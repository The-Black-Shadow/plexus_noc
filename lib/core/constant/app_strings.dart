class AppStrings {
  const AppStrings._();

  static const String envFileName = '.env';
  static const String plexusNocAppTitle = 'Plexus NOC';
  static const String plexusNocAppSubtitle = 'Network Operations Center';

  static const String nocDashboardTitle = 'NOC Dashboard';
  static const String deviceListTitle = 'Device List';
  static const String mapTitle = 'Map';
  static const String unknownTitle = 'Unknown';

  static const String networkOfflineTooltip = 'Offline';
  static const String networkOnlineTooltip = 'Online';
  static const String networkOfflineCachedDataMessage =
      'no internet showing cached data';
  static const String networkReloadActionLabel = 'push to reload';
  static const String toggleThemeTooltip = 'Toggle Theme';

  static const String dashboardTitle = 'Dashboard';
  static const String devicesNavLabel = 'Devices';

  //login
  static const String invalidEmailOrPassword = 'Invalid email or password';
  static const String pleaseEnterYourEmail = 'Please enter your email';
  static const String pleaseEnterYourPassword = 'Please enter your password';
  static const String emailAddress = 'Email Address';
  static const String password = 'Password';
  static const String login = 'Login';
  static const String switchLightMode = 'Switch Light Mode';
  static const String switchDarkMode = 'Switch Dark Mode';

  // Dashboard Page
  static const String networkOverview = 'Network Overview';
  static const String realTimeStatus =
      'Real-time status of your infrastructure';
  static const String totalDevices = 'Total Devices';
  static const String activeAlerts = 'Active Alerts';

  // Notification Service
  static const String notificationChannelId = 'noc_critical_alerts';
  static const String notificationChannelName = 'Critical Alerts';
  static const String notificationChannelDescription =
      'Notifications for offline devices and high CPU usage';
  static const String notificationTicker = 'NOC Alert';
  static const String notificationAppIcon = '@mipmap/ic_launcher';
  static const String notificationTitle = '⚠️ CRITICAL NOC ALERT';

  // Device Monitoring Screen
  static const String searchDevicesHint = 'Search devices by name or IP...';
  static const String filterAll = 'All';
  static const String noDevicesFound = 'No devices found.';
  static const String onlineStatus = 'ONLINE';
  static const String offlineStatus = 'OFFLINE';
  static const String deviceDetailsRoute = 'device_details';

  // Global Alert Dialog
  static const String criticalAlertTitle = 'Critical Alert';
  static const String alertDismiss = 'Okay';

  // Device Details Page
  static const String deviceDetailsTitle = 'Device Details';
  static const String ipAddressLabel = 'IP Address';
  static const String locationLabel = 'Location';
  static const String lastPingLabel = 'Last Ping';
  static const String cpuUsageLabel = 'CPU Usage';
  static const String memoryUsageLabel = 'Memory Usage';

  //Map
  static const String mapDataUnavailable = 'Map data unavailable.';

  // Dashboard – Redesigned
  static const String dashboardSubtitle = 'Real-time monitoring overview';
  static const String online = 'Online';
  static const String offline = 'Offline';
  static const String deviceHealthSummary = 'Device Health Summary';
  static const String recentAlerts = 'Recent Alerts';
  static const String viewAll = 'View All';

  // Notifications Page
  static const String notificationsTitle = 'Notifications';
  static const String noNotifications = 'No notifications yet.';

  // Alert Types
  static const String alertTypeDeviceOffline = 'Device Offline';
  static const String alertTypeHighCpu = 'High CPU Usage';
  static const String alertTypeNetworkLatency = 'Network Latency';

  // Settings Feature
  static const String settingsTitle = 'Settings';
  static const String settingsAppearance = 'Appearance';
  static const String settingsDarkMode = 'Dark Mode';
  static const String settingsDarkModeSubtitle =
      'Toggle between light and dark themes';
}
