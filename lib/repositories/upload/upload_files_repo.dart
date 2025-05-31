// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/helper/helper.dart';

class UploadFilesRepo {
  final ImagePicker _picker = ImagePicker();

  final SupabaseClient client = Supabase.instance.client;

  Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      showCustomSnackBar(
        context,
        message: 'Error picking image: $e',
        isError: true,
      );
      print(e);
      return null;
    }
  }

  Future<String> uploadUserAvatar(
    BuildContext context, {
    required File image,
  }) async {
    try {
      final fileName = image.path.split('/').last;

      final response = await client.storage.from('avatars').upload(
        fileName,
        image,
      );

      if (response.isEmpty) {
        throw Exception('Upload failed: empty response');
      }

      final String publicUrl = client.storage.from('avatars').getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print(e);
      showCustomSnackBar(
        context,
        message: "Error uploading image: $e",
        isError: true,
      );

      return "";
    }
  }

  Future<File?> pickImageFromCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      showCustomSnackBar(
        // ignore: use_build_context_synchronously
        context,
        message: 'Error picking image: $e',
        isError: true,
      );
      return null;
    }
  }
}
