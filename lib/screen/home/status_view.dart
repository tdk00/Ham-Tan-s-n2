import 'package:everyone_know_app/api/main/statuses.dart';
import 'package:everyone_know_app/screen/home/chat_screen.dart';
import 'package:everyone_know_app/view/story/custom_story_view.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:everyone_know_app/widget/story/story_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusViewScreen extends StatefulWidget {
  final bool? checkUserStory;
  final List<StoryItem>? storyItems;
  final String? statusUserName;
  final String? statusUserImgUrl;
  final String? statusImageText;
  final UserInfo? userInfo;
  final String? regionId;

  const StatusViewScreen({
    Key? key,
    this.checkUserStory = false,
    this.storyItems,
    this.statusUserName,
    this.statusUserImgUrl,
    this.statusImageText,
    this.userInfo,
    this.regionId,
  }) : super(key: key);

  @override
  _StatusViewScreenState createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  final StoryController controller = StoryController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomStoryView(
          isMe: widget.checkUserStory ?? false,
          userInfo: widget.userInfo,
          userName: widget.statusUserName ?? "İstifadəçi adı",
          storyItems: widget.storyItems!,
          controller: controller,
          regionId: widget.regionId,
          imageUrl: widget.statusUserImgUrl ?? "https://i.pinimg.com/564x/8b/30/de/8b30dead52fb583f2561eee302f6a672.jpg",
        ),
      ),
      // body: SafeArea(
      //   child: Stack(
      //     children: [
      //       Container(
      //         width: double.infinity,
      //         height: double.infinity,
      //         margin: EdgeInsets.only(
      //           top: screenHeight(context, 0.04),
      //           bottom: widget.checkUserStory == false
      //               ? screenHeight(context, 0.3)
      //               : screenHeight(context, 0.28),
      //         ),
      //         child: CustomStoryView(
      //           userName: widget.statusUserName ?? "Natavan",
      //           storyItems: widget.storyItems,
      //           controller: controller,
      //           imageUrl: widget.statusUserImgUrl ??
      //               "https://i.pinimg.com/564x/8b/30/de/8b30dead52fb583f2561eee302f6a672.jpg",
      //         ),
      //       ),
      //       // Align(
      //       //   alignment: Alignment.bottomCenter,
      //       //   child: Padding(
      //       //     padding: EdgeInsets.only(
      //       //       bottom: widget.checkUserStory == true
      //       //           ? screenHeight(context, 0.12)
      //       //           : screenHeight(context, 0.15),
      //       //       left: 37,
      //       //       right: 37,
      //       //     ),
      //       //     child: CustomTextView(
      //       //       textPaste: widget.statusImageText ??
      //       //           """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis nec dolor tempus, sollicitudin enim et, maximus massa.""",
      //       //       textSize: 16,
      //       //       textAlign: TextAlign.start,
      //       //       textColor: Colors.white,
      //       //       fontWeight: FontWeight.w500,
      //       //     ),
      //       //   ),
      //       // ),
      //       widget.checkUserStory == false
      //           ? const SizedBox()
      //           : Align(
      //               alignment: Alignment.topRight,
      //               child: Padding(
      //                 padding: const EdgeInsets.only(top: 30, right: 10),
      //                 child: IconButton(
      //                   onPressed: () {
      //                     setState(() {
      //                       controller.infoPause();
      //                     });
      //                     showCupertinoDialog(
      //                       context: context,
      //                       builder: (ctx) {
      //                         return Center(
      //                           child: alertDialog(context),
      //                         );
      //                       },
      //                     );
      //                   },
      //                   icon: const Icon(
      //                     Icons.delete_outline,
      //                     color: Colors.white,
      //                     size: 22,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //       widget.checkUserStory == false
      //           ? Align(
      //               alignment: Alignment.bottomCenter,
      //               child: Padding(
      //                 padding: const EdgeInsets.only(bottom: 12),
      //                 child: MessageSendButton(
      //                   sendMessage: () {},
      //                   hideImageIcon: true,
      //                 ),
      //               ),
      //             )
      //           : const SizedBox(),
      //     ],
      //   ),
      // ),
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
                  isStory: true,
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
                child: (widget.statusUserImgUrl != null && widget.statusUserImgUrl != '')
                    ? Image.network(
                        widget.statusUserImgUrl!,
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
                widget.statusUserName ?? 'İstifadəçi adı',
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
              textPaste: "Delete Confirmation",
              textColor: Colors.black,
              textDecoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
              textSize: 18,
            ),
            const CustomTextView(
              textPaste: "Are you sure you want to delete this\nitem?",
              textColor: Colors.black,
              textDecoration: TextDecoration.none,
              fontWeight: FontWeight.w500,
              textSize: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // controller.infoPlay();
                      controller.play();
                      Navigator.pop(context);
                    });
                  },
                  child: const CustomTextView(
                    textPaste: "Delete",
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
                      controller.play();
                      Navigator.pop(context);
                    });
                  },
                  child: const CustomTextView(
                    textPaste: "Cancel",
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
}
