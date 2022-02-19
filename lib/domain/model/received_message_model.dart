class ReceivedMessageModel {
  ReceivedMessageModel({
    this.message,
    this.username,
    this.image,
    this.statusId,
    this.statusImage,
  });

  final String? message;
  final int? username;
  final String? image;
  final String? statusId;
  final String? statusImage;

  ReceivedMessageModel copyWith({
    String? message,
    int? username,
    String? image,
    String? statusId,
    String? statusImage,
  }) {
    return ReceivedMessageModel(
      message: message ?? this.message,
      username: username ?? this.username,
      image: image ?? this.image,
      statusId: statusId ?? this.statusId,
      statusImage: statusImage ?? this.statusImage,
    );
  }

  factory ReceivedMessageModel.fromJson(Map<String, dynamic> json) => ReceivedMessageModel(
        message: json["message"],
        username: json["username"],
        image: json["image"],
        statusId: json["status_id"],
        statusImage: json["status_image"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "username": username,
        "image": image,
        "status_id": statusId,
        "status_image": statusImage,
      };
}
