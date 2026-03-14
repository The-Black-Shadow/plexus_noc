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
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.deviceDetailsTitle)),
        body: const _DeviceDetailsBody(),
      ),
    );
  }
}

class _DeviceDetailsBody extends StatelessWidget {
  const _DeviceDetailsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
      builder: (context, state) => switch (state) {
        DeviceDetailsLoading() =>
          const Center(child: CircularProgressIndicator()),
        DeviceDetailsError(:final message) =>
          Center(child: Text(message)),
        DeviceDetailsLoaded() => _DeviceDetailsContent(state: state),
      },
    );
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
