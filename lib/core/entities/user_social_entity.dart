
import 'social_entity.dart';

class UserSocialEntity {
  final int id;
  final SocialEntity social;
  final String link;
  final DateTime date;
  final String user;

  UserSocialEntity({
    required this.id,
    required this.social,
    required this.link,
    required this.date,
    required this.user,
  });

}