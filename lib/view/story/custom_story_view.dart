import 'package:everyone_know_app/api/main/statuses.dart';
import 'package:everyone_know_app/screen/home/chat_screen.dart';
import 'package:everyone_know_app/view/story/bloc/story_bloc.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';

class CustomStoryView extends StatefulWidget {
  final List<StoryItem?> storyItems;
  final String? imageUrl;
  final String? userName;
  final StoryController controller;
  final UserInfo? userInfo;
  final String? regionId;
  final bool isMe;

  const CustomStoryView({
    Key? key,
    required this.storyItems,
    required this.isMe,
    this.imageUrl,
    this.userName,
    this.regionId,
    required this.userInfo,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomStoryView> createState() => _CustomStoryViewState();
}

class _CustomStoryViewState extends State<CustomStoryView> {
  final StoryBloc _storyBloc = StoryBloc();

  @override
  void dispose() {
    _storyBloc.close();
    super.dispose();
  }

//   String? storyId = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          StoryView(
            controller: widget.controller,
            storyItems: widget.storyItems,
            onStoryShow: (storyItem) {
              String id = storyItem.view.key.toString();

              id = id.replaceAll('[<', '');
              id = id.replaceAll('>]', '');

              _storyBloc.updateStoryId(id);
            },
            onComplete: () {
              Navigator.of(context).pop();
            },
            onVerticalSwipeComplete: (Direction? direction) {
              if (direction == Direction.down) {
                Navigator.of(context).pop();
              }
            },
          ),
          _buildUserInfo(),
          if (widget.isMe)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 10),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.controller.pause();
                    });

                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) {
                        return Center(
                          child: alertDialog(context),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget alertDialog(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 165,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 12,
          left: 14,
          right: 11,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomTextView(
              textPaste: "Sil",
              textColor: Colors.black,
              textDecoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
              textSize: 18,
            ),
            const CustomTextView(
              textPaste: "Həqiqətən silmək istədiyinizə əminsiniz?",
              textColor: Colors.black,
              textDecoration: TextDecoration.none,
              fontWeight: FontWeight.w500,
              textSize: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    //   widget.controller.play();

                    await _storyBloc.deleteStory();

                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: const CustomTextView(
                    textPaste: "Sil",
                    textDecoration: TextDecoration.none,
                    textColor: Color.fromRGBO(48, 156, 244, 1),
                    fontWeight: FontWeight.w400,
                    textSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // controller.infoPlay();

                      widget.controller.play();
                      Navigator.pop(context);
                    });
                  },
                  child: const CustomTextView(
                    textPaste: "Ləğv et",
                    textDecoration: TextDecoration.none,
                    textColor: Color.fromRGBO(48, 156, 244, 1),
                    fontWeight: FontWeight.w400,
                    textSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Align(
      alignment: Alignment.topLeft,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: () async {
          final user = widget.userInfo!;
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('user_id');

          if (user.id != userId) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  userId: int.tryParse(user.id)!,
                  firstname: user.name,
                  lastname: user.surname,
                  image: user.image,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(180, 132, 240, 1),
                ),
                child: (widget.imageUrl != null && widget.imageUrl != '')
                    ? Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: CustomTextView(
                          textPaste: "M",
                          textSize: 16,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              const SizedBox(width: 12.0),
              Text(
                widget.userName ?? 'İstifadəçi adı',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(124, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
