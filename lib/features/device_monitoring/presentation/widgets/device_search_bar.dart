import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_list/device_list_bloc.dart';

class DeviceSearchBar extends StatelessWidget {
  const DeviceSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.searchDevicesHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: theme.cardColor,
        ),
        onChanged: (query) => context
            .read<DeviceListBloc>()
            .add(SearchDevicesEvent(query: query)),
      ),
    );
  }
}
