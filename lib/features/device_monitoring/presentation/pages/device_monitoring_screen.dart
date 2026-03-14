import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_list/device_list_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/device_list_tile.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/device_search_bar.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/device_status_filter_bar.dart';

class DeviceMonitoringScreen extends StatefulWidget {
  const DeviceMonitoringScreen({super.key});

  @override
  State<DeviceMonitoringScreen> createState() => _DeviceMonitoringScreenState();
}

class _DeviceMonitoringScreenState extends State<DeviceMonitoringScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DeviceSearchBar(),
        DeviceStatusFilterBar(),
        SizedBox(height: 8),
        Expanded(child: _DeviceListBody()),
      ],
    );
  }
}

/// Renders the device list, loading, error, and empty states.
///
/// Separated to keep the parent build method under 80 lines and
/// to isolate rebuilds — only this subtree rebuilds on state changes.
class _DeviceListBody extends StatefulWidget {
  const _DeviceListBody();

  @override
  State<_DeviceListBody> createState() => _DeviceListBodyState();
}

class _DeviceListBodyState extends State<_DeviceListBody> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceListBloc, DeviceListState>(
      builder: (context, state) => switch (state) {
        DeviceListLoading() => const Center(child: CircularProgressIndicator()),
        DeviceListError(:final message) => Center(
          child: Text(
            'Error: $message',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        DeviceListLoaded() => _buildDeviceList(context, state),
      },
    );
  }

  Widget _buildDeviceList(BuildContext context, DeviceListLoaded state) {
    if (state.devices.isEmpty) {
      return const Center(child: Text(AppStrings.noDevicesFound));
    }

    final itemCount = state.hasReachedMax
        ? state.devices.length
        : state.devices.length + 1;

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<DeviceListBloc>().add(RefreshDeviceListEvent()),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= state.devices.length) {
            _requestMoreDevices(context);
            return const _BottomLoadingIndicator();
          }
          return DeviceListTile(
            key: ValueKey(state.devices[index].id),
            device: state.devices[index],
          );
        },
      ),
    );
  }

  /// Fires [LoadMoreDevicesEvent] on the next frame to avoid
  /// dispatching events during build.
  void _requestMoreDevices(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DeviceListBloc>().add(LoadMoreDevicesEvent());
      }
    });
  }
}

/// Small spinner shown at the bottom of the list while loading
/// the next page.
class _BottomLoadingIndicator extends StatelessWidget {
  const _BottomLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
