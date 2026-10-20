import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import 'app_text_form_field.dart';

/// Password field with a visibility toggle, built on [AppTextFormField].
class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.visible,
    required this.onToggleVisibility,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
  });

  final String label;
  final bool visible;
  final VoidCallback onToggleVisibility;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? errorText;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      label: label,
      controller: controller,
      obscureText: !visible,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      errorText: errorText,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      trailing: IconButton(
        tooltip: visible ? AppStrings.hidePassword : AppStrings.showPassword,
        onPressed: onToggleVisibility,
        icon: Icon(
          visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textMuted,
          size: 24,
        ),
      ),
    );
  }
}
