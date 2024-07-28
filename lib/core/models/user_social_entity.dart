import '../entities/user_social_entity.dart';
import 'social_model.dart';

class UserSocialModel {
  final int id;
  final SocialModel social;
  final String link;
  final DateTime date;
  final String user;

  UserSocialModel({
    required this.id,
    required this.social,
    required this.link,
    required this.date,
    required this.user,
  });

  factory UserSocialModel.fromJson(Map<String, dynamic> json) {
    return UserSocialModel(
      id: json['id'],
      social: SocialModel.fromJson(json['social']),
      link: json['link'],
      date: DateTime.parse(json['date']),
      user: json['user'],
    );
  }
  UserSocialEntity toEntity() => UserSocialEntity(
      id: id, social: social.toEntity(), link: link, date: date, user: user);
}
