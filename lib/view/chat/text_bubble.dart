import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final ReceivedMessageModel message;
  final bool isOwn;
  final String username;
  final String profilePicture;

  const TextBubble(
    this.message, {
    Key? key,
    required this.isOwn,
    required this.username,
    required this.profilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isOwn)
                Container(
                  width: 36.0,
                  height: 36.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: profileEditImageColor,
                  ),
                  child: Image.network(
                    profilePicture,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, obj, stck) {
                      return Image.asset(
                        'assets/icon.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: messageBubble,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    message.message ?? '',
                    style: const TextStyle(
                      color: messageTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
