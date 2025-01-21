class MediaModel {
  final String id;
  final String mimeType;
  final String url;
  final int type;
  final String incidentId;

  MediaModel({
    required this.id,
    required this.mimeType,
    required this.url,
    required this.type,
    required this.incidentId,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] ?? '',
      mimeType: json['mimeType'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? 0,
      incidentId: json['incidentId'] ?? '',
    );
  }
}
