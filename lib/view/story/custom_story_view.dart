import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class CustomStoryView extends StatelessWidget {
  final List<StoryItem?> storyItems;
  final String? imageUrl;
  final String? userName;
  final StoryController controller;

  const CustomStoryView({
    Key? key,
    required this.storyItems,
    this.imageUrl,
    this.userName,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StoryView(
        controller: controller,
        storyItems: storyItems,
        onComplete: () {
          Navigator.of(context).pop();
        },
        onVerticalSwipeComplete: (Direction? direction) {
          if (direction == Direction.down) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
