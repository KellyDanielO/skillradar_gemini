import 'package:equatable/equatable.dart';

import '../entities/skill_entity.dart';

class SkillModel extends Equatable {
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

  @override
  List<Object?> get props => [id, name];

  SkillEntity toEntity() => SkillEntity(id: id, name: name);
}
