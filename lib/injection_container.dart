import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:plexus_noc/core/network/cubit/network_cubit.dart';
import 'package:plexus_noc/core/network/network_info.dart';
import 'package:plexus_noc/core/services/local_notification_service.dart';
import 'package:plexus_noc/core/theme/cubit/theme_cubit.dart';
import 'package:plexus_noc/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:plexus_noc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:plexus_noc/features/auth/domain/repositories/auth_repository.dart';
import 'package:plexus_noc/features/auth/domain/usecases/login_usecase.dart';
import 'package:plexus_noc/features/auth/presentation/cubit/login_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/data/datasources/device_local_datasource.dart';
import 'package:plexus_noc/features/device_monitoring/data/datasources/device_local_datasource_impl.dart';
import 'package:plexus_noc/features/device_monitoring/data/datasources/device_remote_datasource.dart';
import 'package:plexus_noc/features/device_monitoring/data/datasources/mock_device_datasource.dart';
import 'package:plexus_noc/features/device_monitoring/data/repositories/device_repository_impl.dart';
import 'package:plexus_noc/features/device_monitoring/domain/repositories/device_repository.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/check_internet_connection.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/get_alerts_stream.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/get_devices_stream.dart';
import 'package:plexus_noc/features/device_monitoring/domain/usecases/listen_internet_connection.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/alert/alert_cubit.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_details/device_details_bloc.dart';
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
  sl.registerLazySingleton(() => GetDevicesStreamUseCase(sl()));

  // ── Cubits / Blocs ──
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => SplashCubit());
  sl.registerFactory(() => DashboardBloc(getDevicesStream: sl()));
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(
    () => NetworkCubit(
      checkInternetConnection: sl<CheckInternetConnectionUseCase>(),
      listenInternetConnection: sl<ListenInternetConnectionUseCase>(),
    ),
  );
  sl.registerFactory(
    () => DeviceListBloc(getDevicesStream: sl(), checkInternetConnection: sl()),
  );
  sl.registerFactory(() => DeviceDetailsBloc(getDevicesStream: sl()));

  sl.registerFactory(
    () => AlertCubit(getAlertsStream: sl(), notificationService: sl()),
  );
  //usecases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetAlertsStreamUseCase(sl()));

  //repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => MockDeviceDataSource(),
  );

  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(cacheBox: sl()),
  );
  //services
  final notificationService = LocalNotificationService();
  await notificationService.init();
  sl.registerLazySingleton(() => notificationService);
  // Initialize Hive and open the box before registering it
  await Hive.initFlutter();
  final cacheBox = await Hive.openBox('device_cache_box');
  sl.registerLazySingleton<Box>(() => cacheBox);
}
