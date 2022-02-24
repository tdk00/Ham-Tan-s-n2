import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:everyone_know_app/view/chat/image_bubble.dart';
import 'package:everyone_know_app/view/chat/status_bubble.dart';
import 'package:everyone_know_app/view/chat/text_bubble.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.isMe,
    required this.isStory,
    required this.message,
    this.image,
    required this.fullName,
  }) : super(key: key);

  final bool isMe;
  final bool isStory;
  final ReceivedMessageModel message;
  final String? image;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    if (message.message != null && message.message != '' && (message.statusImage == null || message.statusImage == '') && (message.image == null || message.image == '')) {
      return TextBubble(
        message,
        isOwn: isMe,
        username: fullName,
        profilePicture: image,
      );
    }
    //
    else if (message.image != null && message.image != '') {
      return ImageBubble(
        message,
        isOwn: isMe,
        username: fullName,
        profilePicture: image,
      );
    }
    //
    else if (message.statusImage != null && message.statusImage != '') {
      return StatusBubble(
        message,
        isOwn: isMe,
        username: fullName,
        profilePicture: image,
      );
    }

    return const SizedBox.shrink();
  }
}
