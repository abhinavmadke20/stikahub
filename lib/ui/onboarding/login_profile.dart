import 'package:flutter/material.dart';
import 'package:stikahub/components/components.dart';
import 'package:stikahub/repositories/authentication/authentication_repository.dart';
import 'package:stikahub/theme/theme.dart';
import 'package:stikahub/utils/utils.dart';

class LoginProfile extends StatefulWidget {
  const LoginProfile({super.key});

  @override
  State<LoginProfile> createState() => _LoginProfileState();
}

class _LoginProfileState extends State<LoginProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool visiblityPassword = false;
  final _formKey = GlobalKey<FormState>();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await AuthenticationRepository().signInUser(
        context,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      String errorMessage = 'Please fix the errors in the form';

      if (_emailController.text.isEmpty) {
        errorMessage = 'Email is required';
      } else if (_passwordController.text.isEmpty) {
        errorMessage = 'Password is required';
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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.textColor,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _emailFocusNode.unfocus();
            _passwordFocusNode.unfocus();
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
                        const Text(
                          "Login",
                          style: AppTextStyles.heading,
                        ),
                        addVerticalSpace(AppSpacing.md),
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
                          focusNode: _emailFocusNode,
                          title: "Your Email",
                          controller: _emailController,
                          hintText: "sannidancer69@gmail.com",
                          obscureText: false,
                          validator: (value) =>
                              OnboardingFieldsValidator().validateEmail(
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
                          obscureText: visiblityPassword,
                          validator: (value) =>
                              OnboardingFieldsValidator().validatePassword(value),
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                visiblityPassword = !visiblityPassword;
                              });
                            },
                            child: Icon(
                              visiblityPassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        addVerticalSpace(AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: AppButton(
                            onPressed: _handleLogin,
                            text: "Login",
                          ),
                        ),
                        addVerticalSpace(AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTextStyles.bodyText.copyWith(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Register",
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
