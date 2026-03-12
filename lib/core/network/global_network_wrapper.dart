import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/network/cubit/network_cubit.dart';

class GlobalNetworkWrapper extends StatelessWidget {
  final Widget child;

  const GlobalNetworkWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is NetworkOffline) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(AppStrings.networkOfflineCachedDataMessage),
              duration: const Duration(days: 1),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: AppStrings.networkReloadActionLabel,
                onPressed: () {},
              ),
            ),
          );
        } else if (state is NetworkOnline) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
      child: child,
    );
  }
}
