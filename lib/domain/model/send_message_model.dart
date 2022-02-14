class SendMessageModel {
  SendMessageModel({
    this.message,
    this.image,
  });

  final String? message;
  final String? image;

  SendMessageModel copyWith({
    String? message,
    String? image,
  }) =>
      SendMessageModel(
        message: message ?? this.message,
        image: image ?? this.image,
      );

  factory SendMessageModel.fromJson(Map<String, dynamic> json) => SendMessageModel(
        message: json["message"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "image": image,
      };
}
