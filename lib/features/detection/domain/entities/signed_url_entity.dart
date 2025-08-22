class SignedUrlEntity {
  final String signedUrl;
  final String requestId;
  final String mediaId;

  const SignedUrlEntity({
    required this.signedUrl,
    required this.requestId,
    required this.mediaId,
  });
}
