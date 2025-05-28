import 'package:flutter/material.dart';
import 'package:stikahub/components/components.dart';
import 'package:stikahub/theme/theme.dart';
import 'package:stikahub/utils/utils.dart';

class LoginProfile extends StatefulWidget {
  const LoginProfile({super.key});

  @override
  State<LoginProfile> createState() => _LoginProfileState();
}

class _LoginProfileState extends State<LoginProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool visiblityPassword = false;
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
            _nameFocusNode.unfocus();
            _passwordFocusNode.unfocus();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppTextField(
                        focusNode: _nameFocusNode,
                        title: "Your Name",
                        controller: _nameController,
                        hintText: "Sanni Dancer",
                        obscureText: false,
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
                          onPressed: () {},
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
    );
  }
}
