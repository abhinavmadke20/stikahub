import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stikahub/repositories/authentication/authentication_repository.dart';
import 'package:stikahub/repositories/upload/upload.dart';
import 'package:stikahub/ui/home/home_screen.dart';

import '../theme/theme.dart';
import '../utils/utils.dart';
import 'components.dart';

class UploadAvatarScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  const UploadAvatarScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password});

  @override
  State<UploadAvatarScreen> createState() => _UploadAvatarScreenState();
}

class _UploadAvatarScreenState extends State<UploadAvatarScreen> {
  File? imageFile;
  final UploadFilesRepo _uploadRepo = UploadFilesRepo();
  bool isLoading = false;

  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      final File? pickedImage = await _uploadRepo.pickImageFromGallery(context);

      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
      }
    } catch (e) {
      showCustomSnackBar(
        // ignore: use_build_context_synchronously
        context,
        message: 'Error picking image: $e',
        isError: true,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UploadFilesRepo uploadFilesRepo = UploadFilesRepo();
    AuthenticationRepository authenticationRepository =
        AuthenticationRepository();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.textColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        showCustomBottomSheet(
                          context,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from Gallery'),
                                onTap: () async {
                                  await _pickImage();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                              ),
                              const AppDivider(),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Take Photo'),
                                onTap: () async {
                                  final File? image = await _uploadRepo
                                      .pickImageFromCamera(context);
                                  if (image != null) {
                                    setState(() {
                                      imageFile = image;
                                    });
                                  }
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                              ),
                              const AppDivider(),
                            ],
                          ),
                        );
                      },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: AppColors.borderColor,
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile!) : null,
                      child: imageFile == null
                          ? isLoading
                              ? const AppLoadingIndicator()
                              : const Icon(
                                  Icons.camera_alt_rounded,
                                  size: AppSpacing.xl,
                                  color: Colors.black54,
                                )
                          : null,
                    ),
                    if (imageFile != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              addVerticalSpace(AppSpacing.md),
              Text(
                imageFile == null
                    ? 'Tap to add profile photo'
                    : 'Tap to change photo',
                style: AppTextStyles.bodyText.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              addVerticalSpace(AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: AppButton(
                  onPressed: () async {
                    if (imageFile == null) {
                      showCustomSnackBar(
                        context,
                        message: 'Please select an image first.',
                        isError: false,
                      );
                    } else {
                      String avatarUrl = await uploadFilesRepo.uploadUserAvatar(
                        context,
                        image: imageFile!,
                      );

                      await authenticationRepository.signUpUser(
                        // ignore: use_build_context_synchronously
                        context,
                        name: widget.name,
                        avatar: avatarUrl,
                        email: widget.email,
                        password: widget.password,
                      );

                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  text: "Continue",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
