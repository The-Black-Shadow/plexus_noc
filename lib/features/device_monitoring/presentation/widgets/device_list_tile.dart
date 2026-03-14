import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';

class DeviceListTile extends StatelessWidget {
  final DeviceEntity device;

  const DeviceListTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = device.isOnline
        ? colorScheme.tertiary
        : colorScheme.error;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.15),
          child: Icon(
            device.isOnline ? Icons.check_circle : Icons.cancel,
            color: statusColor,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${device.ipAddress} • ${device.location}'),
        trailing: _StatusBadge(isOnline: device.isOnline, color: statusColor),
        onTap: () => context.goNamed(
          AppStrings.deviceDetailsRoute,
          pathParameters: {'id': device.id},
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.responsive(context)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.responsive(context),
          vertical: 6.responsive(context),
        ),
        child: Text(
          isOnline ? AppStrings.onlineStatus : AppStrings.offlineStatus,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 12.responsive(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
