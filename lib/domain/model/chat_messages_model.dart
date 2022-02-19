// To parse this JSON data, do
//
//     final chatMessagesModel = chatMessagesModelFromJson(jsonString);

import 'dart:convert';

List<ChatMessagesModel> chatMessagesModelFromJson(String str) => List<ChatMessagesModel>.from(json.decode(str).map((x) => ChatMessagesModel.fromJson(x)));

String chatMessagesModelToJson(List<ChatMessagesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatMessagesModel {
  ChatMessagesModel({
    this.id,
    this.receiver,
    this.sender,
    this.message,
    this.image,
    this.statusImage,
    this.threadName,
    this.timestamp,
    this.isRead,
  });

  final int? id;
  final String? receiver;
  final String? sender;
  final String? message;
  final String? image;
  final String? statusImage;
  final String? threadName;
  final DateTime? timestamp;
  final bool? isRead;

  ChatMessagesModel copyWith({
    int? id,
    String? receiver,
    String? sender,
    String? message,
    String? image,
    String? statusImage,
    String? threadName,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatMessagesModel(
      id: id ?? this.id,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      image: image ?? this.image,
      statusImage: statusImage ?? this.statusImage,
      threadName: threadName ?? this.threadName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) => ChatMessagesModel(
        id: json["id"],
        receiver: json["receiver"],
        sender: json["sender"],
        message: json["message"],
        image: json["image"],
        statusImage: json["status_image"],
        threadName: json["thread_name"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiver": receiver,
        "sender": sender,
        "message": message,
        "image": image,
        "status_image": statusImage,
        "thread_name": threadName,
        "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
        "is_read": isRead,
      };
}
