import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@plexus.com' && password == 'password123') {
      return const User(id: '1', email: 'admin@plexus.com', name: 'Admin');
    } else {
      throw Exception(AppStrings.invalidEmailOrPassword);
    }
  }
}
