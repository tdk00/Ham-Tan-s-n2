class ReceivedMessageModel {
  ReceivedMessageModel({
    this.message,
    this.username,
    this.image,
  });

  final String? message;
  final int? username;
  final String? image;

  ReceivedMessageModel copyWith({
    String? message,
    int? username,
    String? image,
  }) =>
      ReceivedMessageModel(
        message: message ?? this.message,
        username: username ?? this.username,
        image: image ?? this.image,
      );

  factory ReceivedMessageModel.fromJson(Map<String, dynamic> json) => ReceivedMessageModel(
        message: json["message"],
        username: json["username"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "username": username,
        "image": image,
      };
}
