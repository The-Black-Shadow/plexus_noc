import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/dashboard_card.dart';

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

    // Start entrance animation
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
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0.responsive(context),
                  vertical: 16.0.responsive(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.networkOverview,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.responsive(context)),
                    Text(
                      AppStrings.realTimeStatus,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24.responsive(context)),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.responsive(context),
                        mainAxisSpacing: 16.responsive(context),
                        childAspectRatio: 0.95,
                        children: [
                          DashboardCard(
                            title: AppStrings.totalDevices,
                            value: state.totalDevices,
                            icon: Icons.router,
                            color: colorScheme.primary,
                            delayIndex: 0,
                            animationController: _entranceController,
                          ),
                          DashboardCard(
                            title: AppStrings.networkOnlineTooltip,
                            value: state.onlineDevices,
                            icon: Icons.check_circle_outline,
                            color: colorScheme.tertiary,
                            delayIndex: 1,
                            animationController: _entranceController,
                          ),
                          DashboardCard(
                            title: AppStrings.networkOfflineTooltip,
                            value: state.offlineDevices,
                            icon: Icons.cancel_outlined,
                            color: colorScheme.error,
                            delayIndex: 2,
                            animationController: _entranceController,
                          ),
                          DashboardCard(
                            title: AppStrings.activeAlerts,
                            value: state.alerts,
                            icon: Icons.warning_amber_rounded,
                            color: Colors.orangeAccent,
                            delayIndex: 3,
                            animationController: _entranceController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
