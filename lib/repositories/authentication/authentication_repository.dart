// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stikahub/models/profile_model.dart';
import 'package:stikahub/utils/utils.dart';

enum AuthStatus {
  signedInWithProfile,
  signedInWithoutProfile,
  signedOut,
  error
}

class AuthenticationRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => auth.authStateChanges();
  
  User? get currentUser => auth.currentUser;
  
  checkAuthentication() async {
    auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isSignedIn", false);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isSignedIn", true);
      }
    });
  }

 Future<bool> checkIfUserAlreadyExists(String uuid) async {
    try {
      if (auth.currentUser == null) {
        print('User not authenticated when checking if user exists');
        return false;
      }

      final querySnapshot = await firestore
          .collection('users')
          .where("uuid", isEqualTo: uuid)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      print('Firestore error checking if user exists: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  Future<bool> isSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isSignedIn") ?? false;
  }

    Future<AuthStatus> getAuthenticationStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool prefsSignedIn = prefs.getBool("isSignedIn") ?? false;
      User? currentUser = auth.currentUser;
      
      if (!prefsSignedIn || currentUser == null) {
        return AuthStatus.signedOut;
      }
      
      // Check if user profile exists in Firestore
      bool profileExists = await checkIfUserAlreadyExists(currentUser.uid);
      
      if (profileExists) {
        return AuthStatus.signedInWithProfile;
      } else {
        return AuthStatus.signedInWithoutProfile;
      }
    } catch (e) {
      print('Error getting authentication status: $e');
      return AuthStatus.error;
    }
  }

  Future<bool> signUpUser(
    BuildContext context, {
    required String name,
    required String avatar,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await createUser(
          context,
          uuid: userCredential.user!.uid,
          name: name,
          email: email,
          avatar: avatar,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isSignedIn", true);

        showCustomSnackBar(context, message: "Account has been created!", isError: false);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code;
      showCustomSnackBar(
        context,
        message: errorMessage,
        isError: true,
      );
      print('Sign up error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Unexpected error during sign up",
        isError: true,
      );
      print('Unexpected sign up error: $e');
      return false;
    }
  }

  Future<bool> signInUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isSignedIn", true);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code;
      showCustomSnackBar(
        context,
        message: errorMessage,
        isError: true,
      );
      print('Sign in error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Unexpected error during sign in",
        isError: true,
      );
      print('Unexpected sign in error: $e');
      return false;
    }
  }

  Future createUser(
    BuildContext context, {
    required String name,
    required String email,
    required String avatar,
    required String uuid,
  }) async {
    ProfileModel data = ProfileModel(
      uuid: uuid,
      name: name,
      avatar: avatar,
      followers: 0,
      following: 0,
      accountType: AccountType.private,
      bio: "",
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    try {
      await firestore.collection("users").doc(uuid).set(
            data.toMap(),
          );
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Failed to create an user",
        isError: true,
      );
      print(e);
    }
  }

Future<bool> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isSignedIn", false);
      
      showCustomSnackBar(context, message: "Successfully signed out!", isError: false);
      return true;
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Error signing out: $e",
        isError: true,
      );
      print('Sign out error: $e');
      return false;
    }
  }

  // Helper method to provide user-friendly error messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  // Helper method for Firestore error messages
  String _getFirestoreErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'permission-denied':
        return 'Access denied. Please check your permissions.';
      case 'not-found':
        return 'Document not found.';
      case 'already-exists':
        return 'Document already exists.';
      case 'resource-exhausted':
        return 'Too many requests. Please try again later.';
      case 'failed-precondition':
        return 'Operation failed due to precondition.';
      case 'aborted':
        return 'Operation was aborted. Please try again.';
      case 'out-of-range':
        return 'Operation was attempted past the valid range.';
      case 'unimplemented':
        return 'Operation is not implemented or supported.';
      case 'internal':
        return 'Internal server error. Please try again.';
      case 'unavailable':
        return 'Service is currently unavailable. Please try again.';
      case 'data-loss':
        return 'Unrecoverable data loss or corruption.';
      case 'unauthenticated':
        return 'User is not authenticated. Please sign in.';
      default:
        return 'Database operation failed. Please try again.';
    }
  }

  Future<bool> resetPassword(BuildContext context, String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showCustomSnackBar(
        context,
        message: "Password reset email sent. Check your inbox.",
        isError: false,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getAuthErrorMessage(e.code);
      showCustomSnackBar(
        context,
        message: errorMessage,
        isError: true,
      );
      return false;
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Failed to send reset email",
        isError: true,
      );
      return false;
    }
  }
}
