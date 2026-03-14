import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/navigation/main_wrapper_screen.dart';
import 'package:plexus_noc/features/auth/presentation/cubit/login_cubit.dart';
import 'package:plexus_noc/features/auth/presentation/pages/login_page.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/pages/dashboard_page.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/pages/device_details_page.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/pages/device_monitoring_screen.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/pages/map_page.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/pages/notifications_page.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/widgets/global_alert_wrapper.dart';
import 'package:plexus_noc/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:plexus_noc/features/splash/presentation/pages/splash_page.dart';
import 'package:plexus_noc/injection_container.dart' as di;

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);


final GlobalKey<NavigatorState> _shellNavigatorDashboardKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellDashboard');
final GlobalKey<NavigatorState> _shellNavigatorListKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellList');
final GlobalKey<NavigatorState> _shellNavigatorMapKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellMap');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // --- SPLASH SCREEN ---
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<SplashCubit>(),
        child: const SplashPage(),
      ),
    ),
    // --- AUTHENTICATION ---
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<LoginCubit>(),
        child: const LoginPage(),
      ),
    ),

    // --- NOTIFICATIONS (full-screen push, not a tab) ---
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NotificationsPage(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        
        return MainWrapperScreen(navigationShell: navigationShell);
      },
      branches: [
        // --- TAB 1: DASHBOARD BRANCH ---
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDashboardKey,
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard', 
              builder: (context, state) => GlobalAlertWrapper(
                navigatorKey: rootNavigatorKey,
                child: const DashboardPage(),
              ),
            ),
          ],
        ),

        // --- TAB 2: DEVICE LIST BRANCH ---
        StatefulShellBranch(
          navigatorKey: _shellNavigatorListKey,
          routes: [
            GoRoute(
              path: '/devices',
              name: 'device_list', 
              builder: (context, state) => const DeviceMonitoringScreen(),
              routes: [
                // SUB-ROUTE: Device Details
                GoRoute(
                  path: ':id',
                  name: 'device_details', 
                  
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    
                    final deviceId = state.pathParameters['id']!;
                    return DeviceDetailsPage(deviceId: deviceId);
                  },
                ),
              ],
            ),
          ],
        ),

        // --- TAB 3: MAP BRANCH ---
        StatefulShellBranch(
          navigatorKey: _shellNavigatorMapKey,
          routes: [
            GoRoute(
              path: '/map',
              name: 'map',
              builder: (context, state) =>
                  const MapPage(), 
            ),
          ],
        ),
      ],
    ),
  ],
);
