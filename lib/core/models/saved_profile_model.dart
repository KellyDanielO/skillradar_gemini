import '../entities/saved_profile_entity.dart';
import 'user_model.dart';

class SavedProfileModel {
  final int id;
  final String user;
  final UserModel profile;
  final String dateSaved;

  SavedProfileModel({
    required this.id,
    required this.user,
    required this.profile,
    required this.dateSaved,
  });

  factory SavedProfileModel.fromJson(Map<String, dynamic> json) {
    return SavedProfileModel(
      id: json['id'],
      user: json['user'],
      profile: UserModel.fromJson(json['profile']),
      dateSaved: json['date_saved'],
    );
  }

  SavedProfileEntity toEntity() => SavedProfileEntity(
        id: id,
        user: user,
        profile: profile.toEntity(),
        dateSaved: dateSaved,
      );

  static List<SavedProfileModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SavedProfileModel.fromJson(json)).toList();
  }
}
