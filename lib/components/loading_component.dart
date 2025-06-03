import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/utils.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        AppAssets.loadingAnimation,
        fit: BoxFit.fill,
        height: 200,
        width: 200,
      ),
    );
  }
}
