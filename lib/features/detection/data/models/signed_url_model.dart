import 'package:true_sight/features/detection/domain/entities/signed_url_entity.dart';

class SignedUrlModel extends SignedUrlEntity {
  const SignedUrlModel({
    required super.signedUrl,
    required super.requestId,
    required super.mediaId,
  });

  factory SignedUrlModel.fromJson(Map<String, dynamic> json) {
    final resp = json['response'] as Map<String, dynamic>? ?? {};
    return SignedUrlModel(
      signedUrl: resp['signedUrl']?.toString() ?? '',
      requestId: json['requestId']?.toString() ?? '',
      mediaId: json['mediaId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "response": {"signedUrl": signedUrl},
      "requestId": requestId,
      "mediaId": mediaId,
    };
  }
}
