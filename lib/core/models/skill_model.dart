import '../entities/skill_entity.dart';

class SkillModel {
  final int id;
  final String name;

  const SkillModel({
    required this.id,
    required this.name,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'],
      name: json['name'],
    );
  }
  static List<SkillModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SkillModel.fromJson(json)).toList();
  }

  SkillEntity toEntity() => SkillEntity(id: id, name: name);
}
