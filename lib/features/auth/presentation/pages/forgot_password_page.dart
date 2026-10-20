import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_message.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/forgot_password/forgot_password_bloc.dart';
import '../bloc/forgot_password/forgot_password_event.dart';
import '../bloc/forgot_password/forgot_password_state.dart';
import '../bloc/form_submission_status.dart';
import '../form_inputs/email_input.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (_) => getIt<ForgotPasswordBloc>(),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen:
            (ForgotPasswordState previous, ForgotPasswordState current) =>
                current.status == FormSubmissionStatus.failure &&
                previous.status != FormSubmissionStatus.failure,
        listener: (BuildContext context, ForgotPasswordState state) {
          AppMessages.show(
            context,
            message: state.errorMessage ?? AppStrings.authUnknown,
            isError: true,
          );
        },
        child: AuthScaffold(
          title: AppStrings.forgotTitle,
          subtitle: AppStrings.forgotSubtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                buildWhen:
                    (
                      ForgotPasswordState previous,
                      ForgotPasswordState current,
                    ) =>
                        previous.email != current.email ||
                        previous.showErrorMessages != current.showErrorMessages,
                builder: (BuildContext context, ForgotPasswordState state) {
                  final EmailInput email = state.email;
                  return AppTextFormField(
                    label: AppStrings.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    enabled: !state.isSubmitting,
                    onChanged:
                        (String value) => context
                            .read<ForgotPasswordBloc>()
                            .add(ForgotEmailChanged(value)),
                    errorText:
                        state.showErrorMessages ? email.error?.message : null,
                  );
                },
              ),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                buildWhen:
                    (
                      ForgotPasswordState previous,
                      ForgotPasswordState current,
                    ) => previous.resetEmailSent != current.resetEmailSent,
                builder: (BuildContext context, ForgotPasswordState state) {
                  if (!state.resetEmailSent) {
                    return const SizedBox.shrink();
                  }
                  return const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: _SuccessBanner(message: AppStrings.resetEmailSent),
                  );
                },
              ),
              const SizedBox(height: 72),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                buildWhen:
                    (
                      ForgotPasswordState previous,
                      ForgotPasswordState current,
                    ) =>
                        previous.isSubmitting != current.isSubmitting ||
                        previous.countdownSeconds != current.countdownSeconds,
                builder: (BuildContext context, ForgotPasswordState state) {
                  final bool coolingDown = state.countdownSeconds > 0;
                  return PrimaryButton(
                    label:
                        coolingDown
                            ? AppStrings.sendCountdown(state.countdownSeconds)
                            : AppStrings.sendButton,
                    isLoading: state.isSubmitting,
                    onPressed:
                        coolingDown
                            ? null
                            : () => context.read<ForgotPasswordBloc>().add(
                              const ForgotSubmitted(),
                            ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.successBackground,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              message,
              style: AppTypography.bodyMuted.copyWith(
                color: AppColors.successForeground,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.check_rounded,
            size: 18,
            color: AppColors.successForeground,
          ),
        ],
      ),
    );
  }
}
