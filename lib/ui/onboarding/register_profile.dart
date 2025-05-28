import 'package:flutter/material.dart';
import 'package:stikahub/components/components.dart';
import 'package:stikahub/theme/theme.dart';
import 'package:stikahub/utils/utils.dart';
import 'login_profile.dart';

class RegisterProfile extends StatefulWidget {
  const RegisterProfile({super.key});

  @override
  State<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends State<RegisterProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool visiblityPassword = false;
  bool visiblityConfirmPassword = false;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Name must not exceed 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (value.length > 128) {
      return 'Password must not exceed 128 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UploadAvatarScreen(),
        ),
      );
    } else {
      String errorMessage = 'Please fix the errors in the form';

      if (_nameController.text.trim().isEmpty) {
        errorMessage = 'Name is required';
      } else if (_passwordController.text.isEmpty) {
        errorMessage = 'Password is required';
      } else if (_confirmPasswordController.text.isEmpty) {
        errorMessage = 'Please confirm your password';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        errorMessage = 'Passwords do not match';
      }

      showCustomSnackBar(
        context,
        message: errorMessage,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _nameFocusNode.unfocus();
            _passwordFocusNode.unfocus();
            _confirmPasswordFocusNode.unfocus();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            AppAssets.logo,
                            width: 150,
                            height: 150,
                          ),
                        ),
                        Text(
                          AppConstants.welcomeScreenDescription,
                          style: AppTextStyles.bodyText.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  addVerticalSpace(AppSpacing.md),
                  const AppDivider(),
                  addVerticalSpace(AppSpacing.md),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextField(
                          focusNode: _nameFocusNode,
                          title: "Your Name",
                          controller: _nameController,
                          hintText: "Sanni Dancer",
                          obscureText: false,
                          validator: _validateName,
                          onSubmit: (value) {},
                        ),
                        addVerticalSpace(AppSpacing.md),
                        AppTextField(
                          onSubmit: (value) {},
                          focusNode: _passwordFocusNode,
                          title: "Password",
                          controller: _passwordController,
                          hintText: "*********",
                          obscureText: !visiblityPassword,
                          validator: _validatePassword,
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                visiblityPassword = !visiblityPassword;
                              });
                            },
                            child: Icon(
                              visiblityPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off_rounded,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        addVerticalSpace(AppSpacing.md),
                        AppTextField(
                          onSubmit: (value) {},
                          focusNode: _confirmPasswordFocusNode,
                          title: "Confirm Password",
                          controller: _confirmPasswordController,
                          hintText: "*********",
                          obscureText: !visiblityConfirmPassword,
                          validator: _validateConfirmPassword,
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                visiblityConfirmPassword =
                                    !visiblityConfirmPassword;
                              });
                            },
                            child: Icon(
                              visiblityConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off_rounded,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        addVerticalSpace(AppSpacing.xl),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: AppButton(
                            onPressed: _handleContinue,
                            text: "Continue",
                          ),
                        ),
                        addVerticalSpace(AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppTextStyles.bodyText.copyWith(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginProfile(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
