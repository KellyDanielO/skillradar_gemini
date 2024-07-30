import 'user_entity.dart';

class SavedProfileEntity {
  final int id;
  final String user;
  final UserEntity profile;
  final String dateSaved;

  SavedProfileEntity({
    required this.id,
    required this.user,
    required this.profile,
    required this.dateSaved,
  });
}
