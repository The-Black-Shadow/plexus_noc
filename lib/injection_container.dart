//
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:plexus_noc/core/network/cubit/network_cubit.dart';
import 'package:plexus_noc/core/network/network_info.dart';
import 'package:plexus_noc/core/theme/cubit/theme_cubit.dart';
import 'package:plexus_noc/features/auth/presentation/cubit/login_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/check_internet_connection.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/listen_internet_connection.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/alert/alert_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_list/device_list_bloc.dart';
import 'package:plexus_noc/features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //internet connection checker
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );
  sl.registerLazySingleton(
    () => CheckInternetConnectionUseCase(sl<NetworkInfo>()),
  );
  sl.registerLazySingleton(
    () => ListenInternetConnectionUseCase(sl<NetworkInfo>()),
  );

  // ── Cubits / Blocs ──
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => SplashCubit());
  sl.registerFactory(() => DashboardBloc());
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(
    () => NetworkCubit(
      checkInternetConnection: sl<CheckInternetConnectionUseCase>(),
      listenInternetConnection: sl<ListenInternetConnectionUseCase>(),
    ),
  );
  sl.registerFactory(() => DeviceListBloc());
  sl.registerFactory(() => AlertCubit());
}
