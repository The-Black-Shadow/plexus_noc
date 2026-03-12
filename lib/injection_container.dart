//
import 'package:get_it/get_it.dart';
import 'package:plexus_noc/core/theme/cubit/theme_cubit.dart';
import 'package:plexus_noc/features/auth/presentation/cubit/login_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:plexus_noc/features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  //Cubits/Blocs
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => SplashCubit());
  sl.registerFactory(() => DashboardBloc());
  sl.registerFactory(() => LoginCubit());
}
