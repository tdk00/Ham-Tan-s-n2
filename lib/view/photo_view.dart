import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoView extends StatelessWidget {
  final String url;

  const PhotoView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if (!details.primaryVelocity!.isNegative) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: const [
            CloseButton(color: Colors.black),
            SizedBox(width: 8.0),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 3.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: url,
                errorWidget: (ctx, _, __) {
                  return Image.asset(
                    'assets/icon.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
