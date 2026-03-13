import 'package:plexus_noc/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:plexus_noc/features/auth/domain/entities/user.dart';
import 'package:plexus_noc/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }
}
