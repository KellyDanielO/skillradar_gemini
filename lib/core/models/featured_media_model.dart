import '../entities/featured_media_entity.dart';

class FeaturedMediaModel {
  final String id;
  final String summary;
  final String media;
  final String user;

  FeaturedMediaModel({
    required this.id,
    required this.summary,
    required this.media,
    required this.user,
  });

  factory FeaturedMediaModel.fromJson(Map<String, dynamic> json) {
    return FeaturedMediaModel(
      id: json['id'],
      summary: json['summary'],
      media: json['media'],
      user: json['user'],
    );
  }

  FeaturedMediaEntity toEntity() =>
      FeaturedMediaEntity(id: id, summary: summary, media: media, user: user);
}
