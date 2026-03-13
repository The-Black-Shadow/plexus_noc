import 'package:equatable/equatable.dart';
import 'package:plexus_noc/core/usecases/usecase.dart';
import 'package:plexus_noc/features/auth/domain/entities/user.dart';
import 'package:plexus_noc/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<Future<User>, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<User> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
