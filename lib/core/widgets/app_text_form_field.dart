import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Labeled text form field styled per the design system, with error text and
/// an optional trailing (e.g. visibility toggle) and prefix icon.
class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.onChanged,
    this.onFieldSubmitted,
    this.trailing,
    this.prefixIcon,
    this.errorText,
    this.enabled = true,
    this.autocorrect = false,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? trailing;
  final Widget? prefixIcon;
  final String? errorText;
  final bool enabled;
  final bool autocorrect;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.error),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTypography.inputLabel),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          autocorrect: autocorrect,
          enableSuggestions: !obscureText,
          style: AppTypography.input,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            suffixIcon: trailing,
            prefixIcon: prefixIcon,
            prefixIconColor: AppColors.textMuted,
            suffixIconColor: AppColors.textMuted,
            enabledBorder: _hasError ? errorBorder : null,
            focusedBorder:
                _hasError
                    ? errorBorder.copyWith(
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    )
                    : null,
          ),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              right: AppSpacing.xxs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text(errorText!, style: AppTypography.error)),
                const SizedBox(width: AppSpacing.xxs),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
