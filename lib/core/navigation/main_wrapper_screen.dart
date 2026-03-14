import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/network/cubit/network_cubit.dart';
import 'package:plexus_noc/core/theme/cubit/theme_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/alert/alert_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_list/device_list_bloc.dart';

class MainWrapperScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperScreen({super.key, required this.navigationShell});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  @override
  void initState() {
    super.initState();
    // only initialize if they haven't been started yet.
    // this screen only builds ONCE after login.
    context.read<DeviceListBloc>().add(StartDeviceListStreamEvent());
    context.read<DashboardBloc>().add(StartDashboardStreamEvent());
    context.read<AlertCubit>().startListening();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,

      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.navigationShell.currentIndex == 0
              ? AppStrings.nocDashboardTitle
              : widget.navigationShell.currentIndex == 1
              ? AppStrings.deviceListTitle
              : widget.navigationShell.currentIndex == 2
              ? AppStrings.mapTitle
              : AppStrings.unknownTitle,
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BlocBuilder<NetworkCubit, NetworkState>(
                builder: (context, state) {
                  if (state is NetworkOffline) {
                    return Tooltip(
                      message: AppStrings.networkOfflineTooltip,
                      child: Icon(
                        Icons.cloud_off,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  } else if (state is NetworkOnline) {
                    return Tooltip(
                      message: AppStrings.networkOnlineTooltip,
                      child: Icon(
                        Icons.cloud_done,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: AppStrings.toggleThemeTooltip,
          ),
        ],
      ),

      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _goBranch,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppStrings.dashboardTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: AppStrings.devicesNavLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: AppStrings.mapTitle,
          ),
        ],
      ),
    );
  }
}
