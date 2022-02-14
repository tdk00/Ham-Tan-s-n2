import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.isMe,
    required this.message,
    this.image,
    required this.fullName,
  }) : super(key: key);

  final bool isMe;
  final ReceivedMessageModel message;
  final String? image;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 24.0),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            message.message!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: textColorGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMe)
            image != null
                ? Container(
                    width: 35.0,
                    height: 35.0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: profileEditImageColor,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/icon.png",
                        ),
                      ),
                    ),
                  ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    textPaste: fullName,
                    textSize: 14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textColor: const Color.fromRGBO(18, 14, 33, 1),
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          message.message!,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: textColorGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
