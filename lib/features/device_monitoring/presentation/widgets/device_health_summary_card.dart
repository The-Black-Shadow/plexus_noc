import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';

class DeviceHealthSummaryCard extends StatelessWidget {
  final int onlineCount;
  final int offlineCount;

  const DeviceHealthSummaryCard({
    super.key,
    required this.onlineCount,
    required this.offlineCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = onlineCount + offlineCount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.responsive(context)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.responsive(context)),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.deviceHealthSummary,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.responsive(context)),
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 120.responsive(context),
                height: 120.responsive(context),
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 35.responsive(context),
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        value: total == 0 ? 1 : onlineCount.toDouble(),
                        color: AppColors.donutOnline,
                        radius: 20.responsive(context),
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: total == 0 ? 1 : offlineCount.toDouble(),
                        color: AppColors.donutOffline,
                        radius: 20.responsive(context),
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 24.responsive(context)),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendRow(
                      color: AppColors.donutOnline,
                      label: AppStrings.online,
                      count: onlineCount,
                    ),
                    SizedBox(height: 12.responsive(context)),
                    _LegendRow(
                      color: AppColors.donutOffline,
                      label: AppStrings.offline,
                      count: offlineCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          count.toString(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
