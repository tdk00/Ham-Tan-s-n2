import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:everyone_know_app/view/photo_view.dart';
import 'package:flutter/material.dart';

class StatusBubble extends StatelessWidget {
  final ReceivedMessageModel message;
  final bool isOwn;
  final String username;
  final String? profilePicture;

  const StatusBubble(
    this.message, {
    Key? key,
    required this.isOwn,
    required this.username,
    this.profilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.height * .2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isOwn)
                Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: profileEditImageColor,
                  ),
                  child: profilePicture != null
                      ? Image.network(
                          profilePicture!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, obj, stck) {
                            return Image.asset(
                              'assets/icon.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/icon.png',
                          fit: BoxFit.cover,
                        ),
                ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PhotoView(url: message.statusImage!);
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isOwn)
                            Container(
                              height: 150.0,
                              width: 2.0,
                              decoration: BoxDecoration(
                                color: messageBubble,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          if (!isOwn) const SizedBox(width: 8.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              message.statusImage ?? '',
                              height: 150.0,
                              width: 96.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (isOwn) const SizedBox(width: 8.0),
                          if (isOwn)
                            Container(
                              height: 150.0,
                              width: 2.0,
                              decoration: BoxDecoration(
                                color: messageBubble,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                        ],
                      ),
                      Container(
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
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
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
