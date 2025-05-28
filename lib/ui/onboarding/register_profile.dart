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
                          validator: (value) =>
                              OnboardingFieldsValidator().validateName(
                            value,
                          ),
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
                          validator: (value) => OnboardingFieldsValidator()
                              .validatePassword(value),
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
                          validator: (value) => OnboardingFieldsValidator()
                              .validateConfirmPassword(
                            value,
                            _passwordController,
                          ),
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
