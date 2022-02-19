import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:everyone_know_app/view/photo_view.dart';
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
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: CustomPaint(
          painter: SpecialChatBubbleThree(
            color: Colors.blue,
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            tail: false,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .7,
            ),
            margin: isMe ? const EdgeInsets.fromLTRB(7, 7, 17, 7) : const EdgeInsets.fromLTRB(17, 7, 7, 7),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Text(
                message.message ?? '',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
    );
    // if (message.message != null) {
    //   return Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: BubbleSpecialThree(
    //       text: message.message!,
    //       isSender: isMe,
    //       color: const Color(0xFF1B97F3),
    //       textStyle: const TextStyle(
    //         fontSize: 20,
    //         color: Colors.white,
    //       ),
    //     ),
    //   );
    // } else {
    //   return _buildImageBubble(context);
    // }

    // if (isMe) {
    //   return Container(
    //     alignment: Alignment.centerRight,
    //     margin: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 16.0),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [
    //         const SizedBox(height: 12.0),
    //         _buildImageBubble(context),
    //         const SizedBox(width: 24.0),
    //         _buildStatusImageBubble(context),
    //         Container(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 16.0,
    //           ),
    //           margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * .1),
    //           child: _buildTextBubble(),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // return Container(
    //   alignment: Alignment.centerLeft,
    //   margin: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 12.0),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       if (!isMe)
    //         image != null
    //             ? Container(
    //                 width: 35.0,
    //                 height: 35.0,
    //                 clipBehavior: Clip.antiAliasWithSaveLayer,
    //                 decoration: const BoxDecoration(
    //                   shape: BoxShape.circle,
    //                 ),
    //                 child: Image.network(
    //                   image!,
    //                   fit: BoxFit.cover,
    //                 ),
    //               )
    //             : Container(
    //                 width: 35,
    //                 height: 35,
    //                 decoration: const BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   color: profileEditImageColor,
    //                   image: DecorationImage(
    //                     fit: BoxFit.cover,
    //                     image: AssetImage(
    //                       "assets/icon.png",
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //       const SizedBox(width: 8.0),
    //       if (message.message != null)
    //         Flexible(
    //           child: Container(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 16.0,
    //               vertical: 10.0,
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 CustomTextView(
    //                   textPaste: fullName,
    //                   textSize: 14,
    //                   maxLines: 2,
    //                   overflow: TextOverflow.ellipsis,
    //                   textColor: const Color.fromRGBO(18, 14, 33, 1),
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //                 const SizedBox(height: 12.0),
    //                 _buildImageBubble(context),
    //                 const SizedBox(height: 12.0),
    //                 _buildStatusImageBubble(context),
    //                 const SizedBox(height: 12.0),
    //                 _buildTextBubble(),
    //               ],
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }

  Widget _buildStatusImageBubble(BuildContext context) {
    if (message.statusImage != null && message.statusImage != '') {
      return SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        child: Row(
          children: [
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PhotoView(url: message.statusImage!);
                  },
                );
              },
              child: Image.network(
                message.statusImage!,
                width: 96.0,
                height: 96.0,
                errorBuilder: (ctx, obj, stck) {
                  return Image.asset(
                    'assets/icon.png',
                    fit: BoxFit.cover,
                    width: 96.0,
                    height: 96.0,
                  );
                },
              ),
            )
          ],
        ),
      );
      //   return GestureDetector(
      //     onTap: () {
      //       showDialog(
      //         context: context,
      //         builder: (context) {
      //           return PhotoView(url: message.statusImage!);
      //         },
      //       );
      //     },
      //     child: Image.network(
      //       message.statusImage!,
      //       width: MediaQuery.of(context).size.height * .15,
      //       height: MediaQuery.of(context).size.height * .15,
      //       errorBuilder: (ctx, obj, stck) {
      //         return Image.asset(
      //           'assets/icon.png',
      //           fit: BoxFit.cover,
      //           width: MediaQuery.of(context).size.height * .15,
      //           height: MediaQuery.of(context).size.height * .15,
      //         );
      //       },
      //     ),
      //   );
      //   return Flexible(
      //     child: Padding(
      //       padding: EdgeInsets.only(left: isMe ? MediaQuery.of(context).size.height * .1 : 0, right: isMe ? 0 : MediaQuery.of(context).size.height * .1),
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      //         children: [
      //           if (isMe)
      //             Flexible(
      //               child: Center(
      //                 child: _buildTextBubble(),
      //               ),
      //             )
      //           else
      //             const SizedBox.shrink(),
      //           GestureDetector(
      //             onTap: () {
      //               showDialog(
      //                 context: context,
      //                 builder: (context) {
      //                   return PhotoView(url: message.statusImage!);
      //                 },
      //               );
      //             },
      //             child: Image.network(
      //               message.statusImage!,
      //               width: MediaQuery.of(context).size.height * .15,
      //               height: MediaQuery.of(context).size.height * .15,
      //               errorBuilder: (ctx, obj, stck) {
      //                 return Image.asset(
      //                   'assets/icon.png',
      //                   fit: BoxFit.cover,
      //                   width: MediaQuery.of(context).size.height * .15,
      //                   height: MediaQuery.of(context).size.height * .15,
      //                 );
      //               },
      //             ),
      //           ),
      //           !isMe
      //               ? Flexible(
      //                   child: _buildTextBubble(),
      //                 )
      //               : const SizedBox.shrink(),
      //         ],
      //       ),
      //     ),
      //   );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildImageBubble(BuildContext context) {
    if (message.image != null && message.image != '') {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return PhotoView(url: message.image!);
            },
          );
        },
        child: Image.network(
          message.image!,
          width: MediaQuery.of(context).size.height * .15,
          height: MediaQuery.of(context).size.height * .15,
          errorBuilder: (ctx, obj, stck) {
            return Image.asset(
              'assets/icon.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.height * .15,
              height: MediaQuery.of(context).size.height * .15,
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTextBubble() {
    if (message.message != null) {
      return Text(
        message.message!,
        style: const TextStyle(
          fontSize: 16.0,
          color: textColorGrey,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class SpecialChatBubbleThree extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleThree({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right bubble curve
        path.quadraticBezierTo(w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

        /// bottom-right tail curve 1
        path.quadraticBezierTo(w - _radius * 1, h, w, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right curve
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);
        // bottom-right tail curve 1
        path.quadraticBezierTo(_radius * .8, h, 0, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(_radius * 1, h, _radius * 1.5, h - _radius * 0.6);

        /// bottom-left bubble curve
        path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);

        /// bottom-left curve
        path.quadraticBezierTo(_radius, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
