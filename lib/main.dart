import 'package:flutter/material.dart';
import 'package:stikahub/ui/home/home_screen.dart';

import 'ui/onboarding/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterProfile(),
    );
  }
}