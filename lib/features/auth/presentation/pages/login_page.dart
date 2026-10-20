import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_message.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/form_submission_status.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';
import '../form_inputs/email_input.dart';
import '../form_inputs/password_input.dart';
import '../widgets/auth_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => getIt<LoginBloc>(),
      child: BlocListener<LoginBloc, LoginState>(
        listenWhen:
            (LoginState previous, LoginState current) =>
                current.status == FormSubmissionStatus.failure &&
                previous.status != FormSubmissionStatus.failure,
        listener: (BuildContext context, LoginState state) {
          AppMessages.show(
            context,
            message: state.errorMessage ?? AppStrings.authUnknown,
            isError: true,
          );
        },
        child: AuthScaffold(
          title: AppStrings.loginTitle,
          subtitle: AppStrings.loginSubtitle,
          showBackButton: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen:
                    (LoginState previous, LoginState current) =>
                        previous.email != current.email ||
                        previous.showErrorMessages != current.showErrorMessages,
                builder: (BuildContext context, LoginState state) {
                  final EmailInput email = state.email;
                  return AppTextFormField(
                    label: AppStrings.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    enabled: !state.isSubmitting,
                    onChanged:
                        (String value) => context.read<LoginBloc>().add(
                          LoginEmailChanged(value),
                        ),
                    errorText:
                        state.showErrorMessages ? email.error?.message : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen:
                    (LoginState previous, LoginState current) =>
                        previous.password != current.password ||
                        previous.showErrorMessages !=
                            current.showErrorMessages ||
                        previous.isSubmitting != current.isSubmitting,
                builder: (BuildContext context, LoginState state) {
                  return PasswordField(
                    label: AppStrings.passwordLabel,
                    visible: _passwordVisible,
                    autofillHints: const <String>[AutofillHints.password],
                    onToggleVisibility:
                        () => setState(
                          () => _passwordVisible = !_passwordVisible,
                        ),
                    onChanged:
                        (String value) => context.read<LoginBloc>().add(
                          LoginPasswordChanged(value),
                        ),
                    errorText:
                        state.showErrorMessages
                            ? state.password.error?.message
                            : null,
                  );
                },
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed:
                      () => context.pushReplacement(AppRoutes.forgotPassword),
                  child: Text(
                    AppStrings.forgotPasswordLink,
                    style: AppTypography.bodyMuted.copyWith(
                      color: AppColors.textDark.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen:
                    (LoginState previous, LoginState current) =>
                        previous.isSubmitting != current.isSubmitting,
                builder: (BuildContext context, LoginState state) {
                  return PrimaryButton(
                    label: AppStrings.loginButton,
                    isLoading: state.isSubmitting,
                    onPressed:
                        () => context.read<LoginBloc>().add(
                          const LoginSubmitted(),
                        ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppStrings.noAccountPrompt,
                    style: AppTypography.bodyMuted,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed:
                        () => context.pushReplacement(AppRoutes.register),
                    child: Text(
                      AppStrings.createAccountAction,
                      style: AppTypography.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
