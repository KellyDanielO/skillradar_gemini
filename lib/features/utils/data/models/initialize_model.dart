import '../../../../core/models/skill_model.dart';
import '../../../../core/models/social_model.dart';
import '../../domain/entities/initilize_entity.dart';

class InitilizeModel {
  final List<SkillModel> skills;
  final List<SocialModel> socials;

  InitilizeModel({required this.skills, required this.socials});

  factory InitilizeModel.fromJson(Map<String, dynamic> json) {
    var skillsList = json['skills'] as List;
    var socialsList = json['socials'] as List;

    List<SkillModel> skills =
        skillsList.map((i) => SkillModel.fromJson(i)).toList();
    List<SocialModel> socials =
        socialsList.map((i) => SocialModel.fromJson(i)).toList();

    return InitilizeModel(
      skills: skills,
      socials: socials,
    );
  }
  InitilizeEntity toEntity() => InitilizeEntity(
        skills: skills.map((skill) => skill.toEntity()).toList(),
        socials: socials.map((social) => social.toEntity()).toList(),
      );
}
