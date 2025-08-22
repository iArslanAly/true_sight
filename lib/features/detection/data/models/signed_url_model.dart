import 'package:true_sight/features/detection/domain/entities/signed_url_entity.dart';

class SignedUrlModel extends SignedUrlEntity {
  const SignedUrlModel({
    required super.signedUrl,
    required super.requestId,
    required super.mediaId,
  });

  factory SignedUrlModel.fromJson(Map<String, dynamic> json) {
    return SignedUrlModel(
      signedUrl: json['response']['signedUrl'] as String,
      requestId: json['requestId'] as String,
      mediaId: json['mediaId'] as String,
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
