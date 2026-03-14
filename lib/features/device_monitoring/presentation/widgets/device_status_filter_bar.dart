import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_list/device_list_bloc.dart';

/// Horizontal row of [ChoiceChip]s to filter devices by status.
///
/// Uses [BlocSelector] to rebuild **only** when the active filter
/// changes, avoiding unnecessary widget tree rebuilds.
class DeviceStatusFilterBar extends StatelessWidget {
  const DeviceStatusFilterBar({super.key});

  static const _filters = [
    (label: AppStrings.filterAll, value: DeviceStatusFilter.all),
    (label: AppStrings.networkOnlineTooltip, value: DeviceStatusFilter.online),
    (label: AppStrings.networkOfflineTooltip, value: DeviceStatusFilter.offline),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DeviceListBloc, DeviceListState, DeviceStatusFilter?>(
      selector: (state) =>
          state is DeviceListLoaded ? state.filter : null,
      builder: (context, activeFilter) {
        if (activeFilter == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: _filters.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(entry.label),
                  selected: activeFilter == entry.value,
                  onSelected: (_) => context
                      .read<DeviceListBloc>()
                      .add(FilterDevicesEvent(status: entry.value)),
                  selectedColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
