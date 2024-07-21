import 'package:equatable/equatable.dart';

import '../../features/auth/domain/entities/token_entity.dart';

class UserEntity extends Equatable {
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
  final TokenEntity? tokens;

  const UserEntity({
    required this.id,
    required this.email,
    this.username,
    this.tokens,
    required this.name,
    this.bio,
    required this.isGoogle,
    required this.skills,
    this.aboutMe,
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
}
