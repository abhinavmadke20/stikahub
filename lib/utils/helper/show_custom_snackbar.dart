import 'package:flutter/material.dart';

import '../../theme/theme.dart';

showCustomSnackBar(
  BuildContext context, {
  required String message,
  required bool isError,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.errorColor : AppColors.secondaryColor,
    ),
  );
}
