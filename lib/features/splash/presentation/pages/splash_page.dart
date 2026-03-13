import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/splash/presentation/cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().startSplash();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          context.goNamed('login');
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.router_outlined,
                size: 100.responsive(context),
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 24.responsive(context)),
              Text(
                AppStrings.plexusNocAppTitle,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 8.responsive(context)),
              Text(
                AppStrings.plexusNocAppSubtitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 48.responsive(context)),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
