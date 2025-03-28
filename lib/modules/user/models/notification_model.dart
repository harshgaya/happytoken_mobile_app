class NotificationModel {
  int status;
  String message;
  int unreadNotifications;
  List<NotificationData> data;
  NotificationModel(
      {required this.data,
      required this.message,
      required this.status,
      required this.unreadNotifications});
  factory NotificationModel.fromJson({required Map<String, dynamic> json}) =>
      NotificationModel(
          unreadNotifications: json['unreadNotifications'],
          data: List<NotificationData>.from(
            json['data'].map(
              (x) => NotificationData.fromJson(json: x),
            ),
          ),
          message: json['message'],
          status: json['status']);
}

class NotificationData {
  String id;
  String? title;
  String? subtitle;
  String? image;
  bool isRead;

  String createdAt;

  NotificationData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationData.fromJson({required Map<String, dynamic> json}) =>
      NotificationData(
        id: json['_id'],
        title: json['title'],
        isRead: json['is_read'],
        subtitle: json['subtitle'],
        image: json['image'] ?? '',
        createdAt: json['created_at'],
      );
}
