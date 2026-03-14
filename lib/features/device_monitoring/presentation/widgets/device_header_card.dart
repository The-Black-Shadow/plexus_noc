import 'package:flutter/material.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/device_entity.dart';

class DeviceHeaderCard extends StatelessWidget {
  final DeviceEntity device;

  const DeviceHeaderCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor =
        device.isOnline ? colorScheme.tertiary : colorScheme.error;

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0.responsive(context)),
        child: Column(
          children: [
            Icon(
              Icons.router,
              size: 64.responsive(context),
              color: colorScheme.primary,
            ),
            SizedBox(height: 8.responsive(context)),
            Text(
              device.name,
              style: TextStyle(
                fontSize: 24.responsive(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.responsive(context)),
            Chip(
              label: Text(
                device.isOnline
                    ? AppStrings.onlineStatus
                    : AppStrings.offlineStatus,
                style: TextStyle(
                  color: colorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: statusColor,
            ),
            const Divider(height: 32),
            _DeviceInfoRow(
              label: AppStrings.ipAddressLabel,
              value: device.ipAddress,
            ),
            _DeviceInfoRow(
              label: AppStrings.locationLabel,
              value: device.location,
            ),
            _DeviceInfoRow(
              label: AppStrings.lastPingLabel,
              value: _formatTime(device.lastPingTime),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _DeviceInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _DeviceInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.responsive(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 16.responsive(context),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.responsive(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
