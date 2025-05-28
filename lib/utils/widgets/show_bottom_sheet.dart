import 'package:flutter/material.dart';
import 'package:stikahub/utils/helper/app_spacing.dart';

import '../../theme/app_colors.dart';

Future<void> showCustomBottomSheet(
  BuildContext context, {
  required Widget child,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: AppColors.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.sm),
      ),
    ),
    builder: (context) {
      return child;
    },
  );
}