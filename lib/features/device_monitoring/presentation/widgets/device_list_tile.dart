import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class DeviceListTile extends StatelessWidget {
  final DeviceEntity device;

  const DeviceListTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final statusColor = device.isOnline
        ? AppColors.accentGreen
        : AppColors.accentRed;
    final iconColor = device.isOnline
        ? AppColors.accentBlue
        : AppColors.accentRed;

    return GestureDetector(
      onTap: () => context.goNamed(
        AppStrings.deviceDetailsRoute,
        pathParameters: {'id': device.id},
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.0.responsive(context),
          vertical: 6.0.responsive(context),
        ),
        padding: EdgeInsets.all(16.0.responsive(context)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16.responsive(context)),
          border: Border.all(
            color: isDark ? AppColors.cardBorderDark : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left Icon Box ──
            Container(
              padding: EdgeInsets.all(12.responsive(context)),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(12.responsive(context)),
              ),
              child: Icon(
                Icons.dns_rounded,
                color: iconColor,
                size: 28.responsive(context),
              ),
            ),
            SizedBox(width: 16.responsive(context)),

            // ── Main Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          device.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20.responsive(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.responsive(context)),

                  // IP Address
                  Text(
                    device.ipAddress,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: iconColor.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.responsive(context)),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.responsive(context),
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.responsive(context)),
                      Expanded(
                        child: Text(
                          device.location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.responsive(context)),

                  // Bottom Row: Status Badge & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(
                        isOnline: device.isOnline,
                        color: statusColor,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.responsive(context),
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.responsive(context)),
                          Text(
                            timeago.format(device.lastPingTime),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact online / offline badge with rounded corners.
class _StatusBadge extends StatelessWidget {
  final bool isOnline;
  final Color color;

  const _StatusBadge({required this.isOnline, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.responsive(context),
        vertical: 4.responsive(context),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12.responsive(context)),
      ),
      child: Text(
        isOnline ? AppStrings.onlineStatus : AppStrings.offlineStatus,
        style: TextStyle(
          color: color,
          fontSize: 12.responsive(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
