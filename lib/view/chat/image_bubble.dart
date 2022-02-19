import 'package:cached_network_image/cached_network_image.dart';
import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:everyone_know_app/view/photo_view.dart';
import 'package:flutter/material.dart';

class ImageBubble extends StatelessWidget {
  final ReceivedMessageModel message;
  final bool isOwn;
  final String username;
  final String profilePicture;

  const ImageBubble(
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
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PhotoView(url: message.image!);
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    decoration: BoxDecoration(
                      color: sendMessageButtonColor.withOpacity(.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: message.image ?? '',
                      ),
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
