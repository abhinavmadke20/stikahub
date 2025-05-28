import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.borderColor,
      thickness: 1.0,
    );
  }
}