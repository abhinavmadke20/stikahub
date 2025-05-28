import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';

class AppTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function(String) onSubmit;
  final Function()? onTap;
  final FocusNode? focusNode;
  final int? maxLines;
  final Widget? suffix;

  const AppTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.validator,
    required this.controller,
    required this.obscureText,
    this.onChanged,
    required this.onSubmit,
    this.onTap,
    this.focusNode,
    this.maxLines,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        addVerticalSpace(AppSpacing.sm),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          onFieldSubmitted: onSubmit,
          onTap: onTap,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            suffix: suffix,
            hintStyle: AppTextStyles.bodyText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
