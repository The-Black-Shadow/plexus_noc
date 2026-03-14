import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_details/device_details_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/device_header_card.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/performance_chart_card.dart';
import 'package:plexus_noc/injection_container.dart' as di;

class DeviceDetailsPage extends StatelessWidget {
  final String deviceId;

  const DeviceDetailsPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<DeviceDetailsBloc>()..add(StartDeviceDetailsStream(deviceId)),
      child: const _DeviceDetailsScaffold(),
    );
  }
}

class _DeviceDetailsScaffold extends StatelessWidget {
  const _DeviceDetailsScaffold();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: _buildBody(state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DeviceDetailsState state) {
    if (state is DeviceDetailsLoaded) {
      final device = state.device;
      final statusColor = device.isOnline ? AppColors.accentGreen : AppColors.accentRed;
      
      return AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              device.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                device.isOnline ? AppStrings.onlineStatus : AppStrings.offlineStatus,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return AppBar(title: const Text(AppStrings.deviceDetailsTitle));
  }

  Widget _buildBody(DeviceDetailsState state) {
    return switch (state) {
      DeviceDetailsLoading() =>
        const Center(child: CircularProgressIndicator()),
      DeviceDetailsError(:final message) => Center(child: Text(message)),
      DeviceDetailsLoaded() => _DeviceDetailsContent(state: state),
    };
  }
}

class _DeviceDetailsContent extends StatelessWidget {
  final DeviceDetailsLoaded state;

  const _DeviceDetailsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cpuColor = isDark ? AppColors.cpuChartDark : AppColors.cpuChartLight;
    final memoryColor =
        isDark ? AppColors.memoryChartDark : AppColors.memoryChartLight;

    return SingleChildScrollView(
      child: Column(
        children: [
          DeviceHeaderCard(device: state.device),
          PerformanceChartCard(
            title:
                '${AppStrings.cpuUsageLabel} (${state.device.cpuUsage.toStringAsFixed(1)}%)',
            dataPoints: state.cpuHistory,
            lineColor: cpuColor,
            minX: state.minX,
            maxX: state.maxX,
          ),
          PerformanceChartCard(
            title:
                '${AppStrings.memoryUsageLabel} (${state.device.memoryUsage.toStringAsFixed(1)}%)',
            dataPoints: state.memoryHistory,
            lineColor: memoryColor,
            minX: state.minX,
            maxX: state.maxX,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
