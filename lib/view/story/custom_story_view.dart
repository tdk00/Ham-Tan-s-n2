import 'package:everyone_know_app/api/main/statuses.dart';
import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/screen/home/chat_screen.dart';
import 'package:everyone_know_app/view/story/bloc/story_bloc.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:everyone_know_app/widget/story/story_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
  final TextEditingController _messageTextEditingController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _storyBloc.updateController(widget.controller);
  }

  @override
  void dispose() {
    _storyBloc.close();
    _messageTextEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log('Bottom ${MediaQuery.of(context).viewInsets.bottom}');
    // if (MediaQuery.of(context).viewInsets.bottom > 0) {
    //   _storyBloc.updateIsKeyboardOpen(true);
    // } else {
    //   _storyBloc.updateIsKeyboardOpen(false);
    // }

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible) {
          _storyBloc.updateIsKeyboardOpen(true);
        } else {
          _storyBloc.updateIsKeyboardOpen(false);
        }

        return StreamBuilder<StoryController>(
          initialData: widget.controller,
          stream: _storyBloc.controller$,
          builder: (context, snapshot) {
            final storyController = snapshot.data!;

            return Stack(
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
                    if (direction == Direction.up) {
                      _focusNode.requestFocus();
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
                          storyController.pause();

                          showCupertinoDialog(
                            context: context,
                            builder: (ctx) {
                              return Center(
                                child: alertDialog(context, storyController),
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
                if (!widget.isMe)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMessageField(storyController),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget alertDialog(BuildContext context, StoryController controller) {
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
                    controller.play();
                    Navigator.of(context).pop();
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
                      errorBuilder: (ctx, obj, stack) {
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
            const SizedBox(width: 12.0),
            Text(
              widget.userName ?? 'İstifadəçi adı',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                fontFamily: "Montserrat",
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
      //   ),
    );
  }

  Widget _buildMessageField(StoryController storyController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        height: 58,
        margin: const EdgeInsets.only(left: 26, right: 26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(66),
          color: Colors.white,
          border: Border.all(
            width: 1.2,
            color: const Color.fromRGBO(41, 41, 44, 0.12),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _messageTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "İsmarıcınızı daxil edin...",
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: textColorGrey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final user = widget.userInfo!;

                      if (_messageTextEditingController.text.trim() != '' &&
                          _messageTextEditingController.text.isNotEmpty) {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: int.tryParse(user.id)!,
                              firstname: user.name,
                              lastname: user.surname,
                              image: user.image,
                              isStory: true,
                              storyMessage: _messageTextEditingController.text,
                              storyId: _storyBloc.storyId,
                            ),
                          ),
                        )
                            .then(
                          (value) {
                            _messageTextEditingController.clear();
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(66),
                        color: sendMessageButtonColor,
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: 20.4,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
