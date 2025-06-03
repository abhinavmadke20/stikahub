import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stikahub/models/profile_model.dart';
import 'package:stikahub/providers/auth/auth_provider.dart';

import '../../components/components.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<UserProfileProvider>();
      if (!profileProvider.hasProfile && !profileProvider.isLoading) {
        profileProvider.getUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Consumer<UserProfileProvider>(
            builder: (context, profileProvider, child) {
              if (profileProvider.isLoading) {
                return const LoadingComponent();
              } else {
                return _TopHeaderHome(
                  userProfile: profileProvider.userProfile,
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {},
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TopHeaderHome extends StatelessWidget {
  final ProfileModel? userProfile;
  const _TopHeaderHome({
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  userProfile?.avatar ?? '',
                ),
              ),
              const Icon(
                Icons.notifications,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}