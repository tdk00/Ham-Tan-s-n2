class MessageListModel {
  MessageListModel({
    this.id,
    this.name,
    this.surname,
    this.message,
    this.isRead,
    this.timestamp,
    this.image,
  });

  final int? id;
  final String? name;
  final String? surname;
  final String? message;
  final bool? isRead;
  final DateTime? timestamp;
  final String? image;

  MessageListModel copyWith({
    int? id,
    String? name,
    String? surname,
    String? message,
    bool? isRead,
    DateTime? timestamp,
    String? image,
  }) =>
      MessageListModel(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        message: message ?? this.message,
        isRead: isRead ?? this.isRead,
        timestamp: timestamp ?? this.timestamp,
        image: image ?? this.image,
      );

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        message: json["message"],
        isRead: json["is_read"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "message": message,
        "is_read": isRead,
        "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
        "image": image,
      };
}
