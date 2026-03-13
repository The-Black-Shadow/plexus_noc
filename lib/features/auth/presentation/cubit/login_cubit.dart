import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/auth/domain/entities/user.dart';
import 'package:plexus_noc/features/auth/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(const LoginInitial());

  Future<void> login(String email, String password) async {
    String? emailError;
    String? passwordError;

    if (email.isEmpty) {
      emailError = AppStrings.pleaseEnterYourEmail;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = AppStrings.invalidEmailOrPassword;
    }

    if (password.isEmpty) {
      passwordError = AppStrings.pleaseEnterYourPassword;
    } else if (password.length < 6) {
      passwordError = AppStrings.invalidEmailOrPassword;
    }

    if (emailError != null || passwordError != null) {
      emit(LoginInitial(emailError: emailError, passwordError: passwordError));
      return;
    }

    emit(LoginLoading());

    try {
      final user = await loginUseCase(
        LoginParams(email: email, password: password),
      );
      emit(LoginSuccess(user: user));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(LoginFailure(message: errorMessage));
    }
  }
}
