import 'package:flutter/foundation.dart';
import 'package:stikahub/models/profile_model.dart';
import '../../repositories/authentication/authentication_repository.dart';

enum ProfileState {
  initial,
  loading,
  loaded,
  error,
  notFound
}

class UserProfileProvider extends ChangeNotifier {
  final AuthenticationRepository _authRepository;
  
  ProfileModel? _userProfile;
  ProfileState _state = ProfileState.initial;
  String? _errorMessage;

  UserProfileProvider(this._authRepository);

  // Getters
  ProfileModel? get userProfile => _userProfile;
  ProfileState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ProfileState.loading;
  bool get hasProfile => _userProfile != null;
  bool get hasError => _state == ProfileState.error;

  // Get user profile data
  Future<void> getUserProfile() async {
    try {
      _setState(ProfileState.loading);
      
      final profile = await _authRepository.getUserProfile();
      _userProfile = profile;
      _setState(ProfileState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ProfileState.error);
      if (kDebugMode) {
        print('Error in UserProfileProvider.getUserProfile: $e');
      }
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await getUserProfile();
  }

  // Update profile locally (useful after profile updates)
  void updateProfile(ProfileModel updatedProfile) {
    _userProfile = updatedProfile;
    _setState(ProfileState.loaded);
  }

  // Update specific profile fields
  void updateProfileField({
    String? name,
    String? avatar,
    String? bio,
    int? followers,
    int? following,
    AccountType? accountType,
  }) {
    if (_userProfile != null) {
      _userProfile = ProfileModel(
        uuid: _userProfile!.uuid,
        name: name ?? _userProfile!.name,
        avatar: avatar ?? _userProfile!.avatar,
        followers: followers ?? _userProfile!.followers,
        following: following ?? _userProfile!.following,
        accountType: accountType ?? _userProfile!.accountType,
        bio: bio ?? _userProfile!.bio,
        createdAt: _userProfile!.createdAt,
      );
      notifyListeners();
    }
  }

  // Clear profile data (useful for sign out)
  void clearProfile() {
    _userProfile = null;
    _errorMessage = null;
    _setState(ProfileState.initial);
  }

  // Check if profile exists and load it
  Future<bool> initializeProfile() async {
    try {
      _setState(ProfileState.loading);
      
      final authStatus = await _authRepository.getAuthenticationStatus();
      
      switch (authStatus) {
        case AuthStatus.signedInWithProfile:
          await getUserProfile();
          return true;
        case AuthStatus.signedInWithoutProfile:
          _setState(ProfileState.notFound);
          return false;
        case AuthStatus.signedOut:
          _setState(ProfileState.initial);
          return false;
        case AuthStatus.error:
          _errorMessage = "Authentication error occurred";
          _setState(ProfileState.error);
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ProfileState.error);
      return false;
    }
  }

  // Helper method to set state and notify listeners
  void _setState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  // Get user's display name (fallback to email if name is empty)
  String get displayName {
    if (_userProfile?.name.isNotEmpty == true) {
      return _userProfile!.name;
    }
    return _authRepository.currentUser?.email ?? 'User';
  }

  // Get user's avatar URL or default
  String get avatarUrl {
    return _userProfile?.avatar ?? '';
  }

  // Check if account is private
  bool get isPrivateAccount {
    return _userProfile?.accountType == AccountType.private;
  }

  // Get formatted follower count
  String get formattedFollowerCount {
    final count = _userProfile?.followers ?? 0;
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  // Get formatted following count
  String get formattedFollowingCount {
    final count = _userProfile?.following ?? 0;
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  @override
  void dispose() {
    super.dispose();
  }
}