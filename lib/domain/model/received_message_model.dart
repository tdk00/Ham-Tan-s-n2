class ReceivedMessageModel {
  ReceivedMessageModel({
    this.message,
    this.sender,
    this.image,
    this.statusId,
    this.statusImage,
  });

  final String? message;
  final int? sender;
  final String? image;
  final String? statusId;
  final String? statusImage;

  ReceivedMessageModel copyWith({
    String? message,
    int? sender,
    String? image,
    String? statusId,
    String? statusImage,
  }) {
    return ReceivedMessageModel(
      message: message ?? this.message,
      sender: sender ?? this.sender,
      image: image ?? this.image,
      statusId: statusId ?? this.statusId,
      statusImage: statusImage ?? this.statusImage,
    );
  }

  factory ReceivedMessageModel.fromJson(Map<String, dynamic> json) => ReceivedMessageModel(
        message: json["message"],
        sender: json["sender"],
        image: json["image"],
        statusId: json["status_id"],
        statusImage: json["status_image"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "sender": sender,
        "image": image,
        "status_id": statusId,
        "status_image": statusImage,
      };
}
