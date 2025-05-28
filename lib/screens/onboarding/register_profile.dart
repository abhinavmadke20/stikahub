import 'package:flutter/material.dart';
import 'package:stikahub/components/components.dart';
import 'package:stikahub/theme/theme.dart';
import 'package:stikahub/utils/utils.dart';

import '../../utils/widgets/divider_widget.dart';

class RegisterProfile extends StatefulWidget {
  const RegisterProfile({super.key});

  @override
  State<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends State<RegisterProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                      "Make wild stickers of your friends. Share ’em, save ’em, and laugh way too hard.",
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
                      focusNode: _passwordFocusNode,
                      title: "Password",
                      controller: _passwordController,
                      hintText: "*********",
                      obscureText: false,
                      onSubmit: (value) {},
                    ),
                    addVerticalSpace(AppSpacing.md),
                    AppTextField(
                      focusNode: _confirmPasswordFocusNode,
                      title: "Confirm Password",
                      controller: _confirmPasswordController,
                      hintText: "*********",
                      obscureText: false,
                      onSubmit: (value) {},
                    ),
                    addVerticalSpace(AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: AppButton(
                        onPressed: () {},
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
                          onTap: () {},
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
    );
  }
}
