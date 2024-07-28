
import '../../features/auth/domain/entities/token_entity.dart';
import 'featured_media_entity.dart';
import 'skill_entity.dart';
import 'user_social_entity.dart';

class UserEntity  {
  final String id;
  final String email;
  final String? username;
  final String name;
  final String? bio;
  final bool isGoogle;
  final List<SkillEntity> skills;
  final String? aboutMe;
  final String? website;
  final String? avatar;
  final String accountType;
  final bool isActive;
  final DateTime dateJoined;
  final String? location;
  final TokenEntity? tokens;
  final String? coverPhoto;
  final List<FeaturedMediaEntity> featured;
  final List<UserSocialEntity> socials;
  final String? phoneNumber;
  final bool showEmail;
  final bool showProfile;
  final bool showPhoneNumber;
  final bool isSaved;

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
    this.coverPhoto,
    required this.featured,
    required this.socials,
    this.phoneNumber,
    required this.isSaved,
    required this.showEmail,
    required this.showProfile,
    required this.showPhoneNumber,
  });
}
