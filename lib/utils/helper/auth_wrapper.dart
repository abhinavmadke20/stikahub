import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stikahub/ui/home/home_screen.dart';
import 'package:stikahub/ui/onboarding/onboarding.dart';

import '../../repositories/authentication/authentication_repository.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  bool isLoading = true;
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationState();
  }

  Future<void> _checkAuthenticationState() async {
    try {
      bool signedInFromPrefs = await _authRepo.isSignedIn();
      
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      bool userIsSignedIn = signedInFromPrefs && currentUser != null;
      
      setState(() {
        isSignedIn = userIsSignedIn;
        isLoading = false;
      });

      _setupAuthListener();
      
    } catch (e) {
      print('Error checking authentication state: $e');
      setState(() {
        isSignedIn = false;
        isLoading = false;
      });
    }
  }

  void _setupAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      if (user == null) {
        prefs.setBool("isSignedIn", false);
        if (mounted) {
          setState(() {
            isSignedIn = false;
          });
        }
      } else {
        prefs.setBool("isSignedIn", true);
        if (mounted) {
          setState(() {
            isSignedIn = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isSignedIn) {
      return const HomeScreen();
    } else {
      return const RegisterProfile();
    }
  }
}