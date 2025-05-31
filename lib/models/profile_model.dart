// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum AccountType { private, public }

class ProfileModel {
  final String uuid;
  final String name;
  final String avatar;
  final int followers;
  final int following;
  final AccountType accountType;
  final String bio;
  final int createdAt;

  ProfileModel({
    required this.uuid,
    required this.name,
    required this.avatar,
    required this.followers,
    required this.following,
    required this.accountType,
    required this.bio,
    required this.createdAt,
  });

  ProfileModel copyWith({
    String? uuid,
    String? name,
    String? avatar,
    int? followers,
    int? following,
    AccountType? accountType,
    String? bio,
    int? createdAt,
  }) {
    return ProfileModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      accountType: accountType ?? this.accountType,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'avatar': avatar,
      'followers': followers,
      'following': following,
      'accountType': accountType.name,
      'bio': bio,
      'createdAt': createdAt,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      followers: map['followers'] as int,
      following: map['following'] as int,
      accountType: AccountType.values.firstWhere((e) => e.name == map['accountType']),
      bio: map['bio'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(uuid: $uuid, name: $name, avatar: $avatar, followers: $followers, following: $following, accountType: $accountType, bio: $bio, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.name == name &&
      other.avatar == avatar &&
      other.followers == followers &&
      other.following == following &&
      other.accountType == accountType &&
      other.bio == bio &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
      name.hashCode ^
      avatar.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      accountType.hashCode ^
      bio.hashCode ^
      createdAt.hashCode;
  }
}
