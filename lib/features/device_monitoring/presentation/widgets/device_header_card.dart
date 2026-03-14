import 'package:flutter/material.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class DeviceHeaderCard extends StatelessWidget {
  final DeviceEntity device;

  const DeviceHeaderCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0.responsive(context),
        vertical: 16.0.responsive(context),
      ),
      padding: EdgeInsets.all(20.0.responsive(context)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.responsive(context)),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Device Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.responsive(context),
            ),
          ),
          SizedBox(height: 24.responsive(context)),

          // ── IP Address ──
          _DeviceInfoRow(
            label: AppStrings.ipAddressLabel,
            valueWidget: Text(
              device.ipAddress,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.responsive(context),
              ),
            ),
          ),

          // ── Location ──
          _DeviceInfoRow(
            label: AppStrings.locationLabel,
            valueWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.responsive(context),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 4.responsive(context)),
                Text(
                  device.location,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.responsive(context),
                  ),
                ),
              ],
            ),
          ),

          // ── Last Ping ──
          _DeviceInfoRow(
            label: AppStrings.lastPingLabel,
            valueWidget: Text(
              timeago.format(device.lastPingTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.responsive(context),
              ),
            ),
          ),

          // ── Status ──
          _DeviceInfoRow(
            label: 'Status',
            valueWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.show_chart_rounded, // or ssid_chart
                  size: 16.responsive(context),
                  color: AppColors.accentGreen,
                ),
                SizedBox(width: 4.responsive(context)),
                Text(
                  device.isOnline ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.responsive(context),
                    color: device.isOnline
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceInfoRow extends StatelessWidget {
  final String label;
  final Widget valueWidget;

  const _DeviceInfoRow({required this.label, required this.valueWidget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.responsive(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 15.responsive(context),
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }
}
