import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import 'token_model.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String name;
  final String? bio;
  final bool isGoogle;
  final List<String> skills;
  final String? aboutMe;
  final String? website;
  final String? avatar;
  final String accountType;
  final bool isActive;
  final DateTime dateJoined;
  final String? location;
  TokenModel? tokens;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    required this.name,
    this.bio,
    required this.isGoogle,
    required this.skills,
    this.aboutMe,
    this.tokens,
    this.website,
    this.avatar,
    required this.accountType,
    required this.isActive,
    required this.dateJoined,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        name,
        bio,
        isGoogle,
        skills,
        aboutMe,
        website,
        avatar,
        accountType,
        isActive,
        dateJoined,
        location,
        tokens,
      ];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      name: json['name'] as String,
      bio: json['bio'] as String?,
      isGoogle: json['is_google'] as bool,
      skills: List<String>.from(json['skills']),
      aboutMe: json['about_me'] as String?,
      website: json['website'] as String?,
      avatar: json['avatar'] as String?,
      accountType: json['account_type'] as String,
      isActive: json['is_active'] as bool,
      dateJoined: DateTime.parse(json['date_joined'] as String),
      location: json['location'] as String?,
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        name: name,
        isGoogle: isGoogle,
        skills: skills,
        accountType: accountType,
        isActive: isActive,
        dateJoined: dateJoined,
        tokens: tokens!.toEntity(),
      );
}
