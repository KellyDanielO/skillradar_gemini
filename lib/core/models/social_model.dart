import '../entities/social_entity.dart';

class SocialModel {
  final int id;
  final String name;
  final String logo;

  SocialModel({required this.id, required this.name, required this.logo});

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
  SocialEntity toEntity() => SocialEntity(id: id, name: name, logo: logo);
}