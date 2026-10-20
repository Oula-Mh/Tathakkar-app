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
import '../bloc/register/register_bloc.dart';
import '../bloc/register/register_event.dart';
import '../bloc/register/register_state.dart';
import '../form_inputs/confirm_password_input.dart';
import '../form_inputs/email_input.dart';
import '../form_inputs/name_input.dart';
import '../form_inputs/password_input.dart';
import '../widgets/auth_scaffold.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (_) => getIt<RegisterBloc>(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listenWhen:
            (RegisterState previous, RegisterState current) =>
                current.status == FormSubmissionStatus.failure &&
                previous.status != FormSubmissionStatus.failure,
        listener: (BuildContext context, RegisterState state) {
          AppMessages.show(
            context,
            message: state.errorMessage ?? AppStrings.authUnknown,
            isError: true,
          );
        },
        child: AuthScaffold(
          title: AppStrings.registerTitle,
          subtitle: AppStrings.registerSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen:
                    (RegisterState previous, RegisterState current) =>
                        previous.name != current.name ||
                        previous.showErrorMessages != current.showErrorMessages,
                builder: (BuildContext context, RegisterState state) {
                  final NameInput name = state.name;
                  return AppTextFormField(
                    label: AppStrings.fullNameLabel,
                    autofillHints: const <String>[AutofillHints.name],
                    enabled: !state.isSubmitting,
                    onChanged:
                        (String value) => context.read<RegisterBloc>().add(
                          RegisterNameChanged(value),
                        ),
                    errorText:
                        state.showErrorMessages ? name.error?.message : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen:
                    (RegisterState previous, RegisterState current) =>
                        previous.email != current.email ||
                        previous.showErrorMessages != current.showErrorMessages,
                builder: (BuildContext context, RegisterState state) {
                  final EmailInput email = state.email;
                  return AppTextFormField(
                    label: AppStrings.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    enabled: !state.isSubmitting,
                    onChanged:
                        (String value) => context.read<RegisterBloc>().add(
                          RegisterEmailChanged(value),
                        ),
                    errorText:
                        state.showErrorMessages ? email.error?.message : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen:
                    (RegisterState previous, RegisterState current) =>
                        previous.password != current.password ||
                        previous.showErrorMessages !=
                            current.showErrorMessages ||
                        previous.isSubmitting != current.isSubmitting,
                builder: (BuildContext context, RegisterState state) {
                  return PasswordField(
                    label: AppStrings.passwordLabel,
                    visible: _passwordVisible,
                    autofillHints: const <String>[AutofillHints.newPassword],
                    onToggleVisibility:
                        () => setState(
                          () => _passwordVisible = !_passwordVisible,
                        ),
                    onChanged:
                        (String value) => context.read<RegisterBloc>().add(
                          RegisterPasswordChanged(value),
                        ),
                    errorText:
                        state.showErrorMessages
                            ? state.password.error?.message
                            : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen:
                    (RegisterState previous, RegisterState current) =>
                        previous.confirmPassword != current.confirmPassword ||
                        previous.showErrorMessages !=
                            current.showErrorMessages ||
                        previous.isSubmitting != current.isSubmitting,
                builder: (BuildContext context, RegisterState state) {
                  return PasswordField(
                    label: AppStrings.confirmPasswordLabel,
                    visible: _confirmPasswordVisible,
                    onToggleVisibility:
                        () => setState(
                          () =>
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible,
                        ),
                    onChanged:
                        (String value) => context.read<RegisterBloc>().add(
                          RegisterConfirmPasswordChanged(value),
                        ),
                    errorText:
                        state.showErrorMessages
                            ? state.confirmPassword.error?.message
                            : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen:
                    (RegisterState previous, RegisterState current) =>
                        previous.isSubmitting != current.isSubmitting,
                builder: (BuildContext context, RegisterState state) {
                  return PrimaryButton(
                    label: AppStrings.registerButton,
                    isLoading: state.isSubmitting,
                    onPressed:
                        () => context.read<RegisterBloc>().add(
                          const RegisterSubmitted(),
                        ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppStrings.hasAccountPrompt,
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
                    onPressed: () => context.pushReplacement(AppRoutes.login),
                    child: Text(
                      AppStrings.loginAction,
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
