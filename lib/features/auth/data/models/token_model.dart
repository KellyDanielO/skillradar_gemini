import 'package:equatable/equatable.dart';

import '../../domain/entities/token_entity.dart';

class TokenModel extends Equatable{
  final String accessToken;
  final String refreshToken;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
  });
  
  @override
  List<Object?> get props => [accessToken, refreshToken];

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  TokenEntity toEntity() => TokenEntity(accessToken: accessToken, refreshToken: refreshToken);
}
