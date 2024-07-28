import '../entities/user_entity.dart';
import '../../features/auth/data/models/token_model.dart';
import 'featured_media_model.dart';
import 'skill_model.dart';
import 'user_social_entity.dart';

// ignore: must_be_immutable
class UserModel {
  final String id;
  final String email;
  final String? username;
  final String name;
  final String? bio;
  final bool isGoogle;
  final List<SkillModel> skills;
  final String? aboutMe;
  final String? website;
  final String? avatar;
  final String accountType;
  final bool isActive;
  final DateTime dateJoined;
  final String? location;
  TokenModel? tokens;
  final String? coverPhoto;
  final List<FeaturedMediaModel> featured;
  final List<UserSocialModel> socials;
  final String? phoneNumber;
  final bool showEmail;
  final bool showProfile;
  final bool showPhoneNumber;
  final bool isSaved;

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
    this.coverPhoto,
    required this.featured,
    required this.socials,
    this.phoneNumber,
    required this.isSaved,
    required this.showEmail,
    required this.showProfile,
    required this.showPhoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var featuredList = json['featured'] as List;
    var socialsList = json['socials'] as List;
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      name: json['name'] as String,
      bio: json['bio'] as String?,
      isGoogle: json['is_google'] as bool,
      skills: (json['skills'] as List)
          .map((skill) => SkillModel.fromJson(skill as Map<String, dynamic>))
          .toList(),
      aboutMe: json['about_me'] as String?,
      website: json['website'] as String?,
      avatar: json['avatar'] as String?,
      accountType: json['account_type'] as String,
      isActive: json['is_active'] as bool,
      dateJoined: DateTime.parse(json['date_joined'] as String),
      location: json['location'] as String?,
      coverPhoto: json['cover_photo'],
      featured:
          featuredList.map((i) => FeaturedMediaModel.fromJson(i)).toList(),
      phoneNumber: json['phone_number'],
      showEmail: json['show_email'],
      showProfile: json['show_profile'],
      showPhoneNumber: json['show_phone_number'],
      isSaved: json['is_saved'],
      socials: socialsList.map((i) => UserSocialModel.fromJson(i)).toList(),
    );
  }

  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        username: username,
        aboutMe: aboutMe,
        avatar: avatar,
        bio: bio,
        location: location,
        website: website,
        name: name,
        isGoogle: isGoogle,
        skills: skills.map((skill) => skill.toEntity()).toList(),
        accountType: accountType,
        isActive: isActive,
        dateJoined: dateJoined,
        tokens: tokens?.toEntity(),
        featured: featured.map((feature) => feature.toEntity()).toList(),
        showEmail: showEmail,
        showPhoneNumber: showPhoneNumber,
        showProfile: showProfile,
        coverPhoto: coverPhoto,
        phoneNumber: phoneNumber,
        isSaved: isSaved,
        socials: socials.map((social) => social.toEntity()).toList(),
      );
}
