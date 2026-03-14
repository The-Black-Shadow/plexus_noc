import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';
import 'package:plexus_noc/features/settings/presentation/cubits/theme/theme_cubit.dart';
import 'package:plexus_noc/features/auth/presentation/cubit/login_cubit.dart';
import 'package:plexus_noc/features/auth/presentation/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    context.read<LoginCubit>().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state is LoginSuccess) {
            context.goNamed('dashboard');
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.responsive(context),
                    vertical: 24.0.responsive(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.router_outlined,
                        size: 80.responsive(context),
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(height: 16.responsive(context)),
                      Text(
                        AppStrings.plexusNocAppTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 8.responsive(context)),
                      Text(
                        AppStrings.signInToAccessTheCommandCenter,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 32.responsive(context)),

                      // ── Form Card ──
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 4.responsive(context),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(28.0.responsive(context)),
                          child: BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              String? emailError;
                              String? passwordError;
                              bool isLoading = state is LoginLoading;

                              if (state is LoginInitial) {
                                emailError = state.emailError;
                                passwordError = state.passwordError;
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AuthTextField(
                                    controller: _emailController,
                                    labelText: AppStrings.emailAddress,
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    errorText: emailError,
                                  ),
                                  SizedBox(height: 16.responsive(context)),

                                  AuthTextField(
                                    controller: _passwordController,
                                    labelText: AppStrings.password,
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _onLoginPressed(),
                                    errorText: passwordError,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 32.responsive(context)),

                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: isDark
                                          ? AppColors.primaryGradientDark
                                          : AppColors.primaryGradientLight,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (isDark
                                                      ? AppColors.primaryDark
                                                      : AppColors.primaryLight)
                                                  .withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : _onLoginPressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.responsive(context),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                              height: 24.responsive(context),
                                              width: 24.responsive(context),
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                            )
                                          : Text(
                                              AppStrings.login,
                                              style: TextStyle(
                                                fontSize: 16.responsive(
                                                  context,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Theme Toggle (Top Right) ──
              Positioned(
                top: 16.responsive(context),
                right: 16.responsive(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                    border: isDark
                        ? Border.all(color: AppColors.cardBorderDark)
                        : null,
                  ),
                  child: IconButton(
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: isDark
                        ? AppStrings.switchLightMode
                        : AppStrings.switchDarkMode,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
