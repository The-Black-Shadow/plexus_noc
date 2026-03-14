import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/alert/alert_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/dashboard_card.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/device_health_summary_card.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/recent_alert_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(StartDashboardStreamEvent());

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutQuart,
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DashboardLoaded) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _DashboardContent(
                state: state,
                entranceController: _entranceController,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// Main scrollable dashboard body. Extracted to keep the parent
/// build method under 80 lines.
class _DashboardContent extends StatelessWidget {
  final DashboardLoaded state;
  final AnimationController entranceController;

  const _DashboardContent({
    required this.state,
    required this.entranceController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(StartDashboardStreamEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.responsive(context),
          vertical: 16.0.responsive(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Text(
              AppStrings.networkOverview,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4.responsive(context)),
            Text(
              AppStrings.dashboardSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20.responsive(context)),

            // ── 2×2 Stats Grid ──
            _StatsGrid(state: state, entranceController: entranceController),
            SizedBox(height: 20.responsive(context)),

            // ── Device Health Summary (Donut Chart) ──
            DeviceHealthSummaryCard(
              onlineCount: state.onlineDevices,
              offlineCount: state.offlineDevices,
            ),
            SizedBox(height: 24.responsive(context)),

            // ── Recent Alerts ──
            _RecentAlertsSection(),
          ],
        ),
      ),
    );
  }
}

/// 2×2 grid of stat cards. Kept as a separate widget to isolate
/// its layout from the rest of the scrollable content.
class _StatsGrid extends StatelessWidget {
  final DashboardLoaded state;
  final AnimationController entranceController;

  const _StatsGrid({required this.state, required this.entranceController});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14.responsive(context),
      mainAxisSpacing: 14.responsive(context),
      childAspectRatio: 1.1,
      children: [
        DashboardCard(
          title: AppStrings.totalDevices,
          value: state.totalDevices,
          icon: Icons.dns_rounded,
          color: AppColors.accentBlue,
          delayIndex: 0,
          animationController: entranceController,
        ),
        DashboardCard(
          title: AppStrings.online,
          value: state.onlineDevices,
          icon: Icons.check_circle_outline,
          color: AppColors.accentGreen,
          delayIndex: 1,
          animationController: entranceController,
        ),
        DashboardCard(
          title: AppStrings.offline,
          value: state.offlineDevices,
          icon: Icons.cancel_outlined,
          color: colorScheme.error,
          delayIndex: 2,
          animationController: entranceController,
        ),
        DashboardCard(
          title: AppStrings.activeAlerts,
          value: state.alerts,
          icon: Icons.warning_amber_rounded,
          color: isDark ? AppColors.warningDark : AppColors.warningLight,
          delayIndex: 3,
          animationController: entranceController,
        ),
      ],
    );
  }
}

/// "Recent Alerts" section header + list of last 10 alerts.
class _RecentAlertsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AlertCubit, AlertState>(
      builder: (context, _) {
        final cubit = context.read<AlertCubit>();
        final recentAlerts = cubit.alertHistory.take(5).toList();

        return Column(
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.recentAlerts,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (recentAlerts.isNotEmpty)
                  TextButton(
                    onPressed: () => context.pushNamed('notifications'),
                    child: Text(
                      AppStrings.viewAll,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.responsive(context)),
            // Alert list
            if (recentAlerts.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.responsive(context)),
                child: Text(
                  AppStrings.noNotifications,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...recentAlerts.map(
                (alert) => RecentAlertTile(
                  key: ValueKey(
                    '${alert.deviceId}_${alert.timestamp.millisecondsSinceEpoch}',
                  ),
                  alert: alert,
                ),
              ),
            SizedBox(height: 16.responsive(context)),
          ],
        );
      },
    );
  }
}
