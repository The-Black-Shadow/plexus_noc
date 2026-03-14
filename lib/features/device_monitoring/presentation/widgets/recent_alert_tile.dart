import 'package:flutter/material.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentAlertTile extends StatelessWidget {
  final AlertEntity alert;

  const RecentAlertTile({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (icon, iconColor) = _resolveIcon(alert.alertType);

    return Container(
      margin: EdgeInsets.only(bottom: 10.responsive(context)),
      padding: EdgeInsets.symmetric(
        horizontal: 16.responsive(context),
        vertical: 14.responsive(context),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(14.responsive(context)),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Alert type icon
          Container(
            padding: EdgeInsets.all(8.responsive(context)),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.15 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.responsive(context)),
          ),
          SizedBox(width: 14.responsive(context)),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.alertType,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.responsive(context)),
                Text(
                  '${alert.deviceName} - ${alert.message}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.responsive(context)),
                Text(
                  timeago.format(alert.timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _resolveIcon(String alertType) {
    return switch (alertType) {
      AppStrings.alertTypeDeviceOffline => (Icons.cancel_outlined, AppColors.accentRed),
      AppStrings.alertTypeHighCpu => (Icons.warning_amber_rounded, AppColors.accentOrange),
      AppStrings.alertTypeNetworkLatency => (Icons.warning_amber_rounded, AppColors.accentOrange),
      _ => (Icons.info_outline, AppColors.accentBlue),
    };
  }
}
