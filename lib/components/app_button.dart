import 'package:flutter/material.dart';
import 'package:stikahub/theme/app_colors.dart';
import 'package:stikahub/theme/text_styles.dart';
import '../utils/utils.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  const AppButton({super.key, required this.onPressed, required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryColor,
        foregroundColor: textColor ?? AppColors.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
      child: Text(text, style: AppTextStyles.buttonText,),
    );
  }
}