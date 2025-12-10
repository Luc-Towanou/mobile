class AppNotification {
  final String id;
  final String message;
  final bool isRead;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      // Le message est imbriqué dans l'objet "data"
      message: json['data'] != null ? json['data']['message'] : 'Nouvelle notification',
      isRead: json['read_at'] != null,
      createdAt: json['created_at'],
    );
  }
}