import 'package:everyone_know_app/view/chat/message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_appbar.dart';
import 'package:everyone_know_app/domain/state/chat_cubit/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  final int userId;
  final String? firstname;
  final String? lastname;
  final String? image;
  final bool isStory;
  final String? storyMessage;
  final String? storyImage;
  final String? storyId;

  const ChatScreen({
    Key? key,
    required this.userId,
    this.firstname,
    this.lastname,
    this.image,
    required this.isStory,
    this.storyMessage,
    this.storyImage,
    this.storyId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatCubit _cubit = ChatCubit();

  final TextEditingController _messageEditingController = TextEditingController();

  @override
  void dispose() {
    _messageEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget.isStory) {
          return _cubit
            ..init('${widget.userId}').then(
              (value) {
                _cubit.sendMessage(
                  widget.storyMessage!,
                  statusId: widget.storyId,
                  statusImage: widget.storyImage,
                );
              },
            );
        }

        return _cubit..init('${widget.userId}');
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            child: SafeArea(
              child: CustomAppBarComponent(appBarText: (widget.firstname ?? '') + ' ' + (widget.lastname ?? '')),
            ),
            preferredSize: const Size.fromHeight(62.0),
          ),
          body: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatAlert) {
                Fluttertoast.showToast(msg: state.message);
              }
            },
            builder: (context, state) {
              if (state is ChatFetched) {
                return _buildBody(state);
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  Widget _buildBody(ChatFetched state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12.0),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages.elementAt(index);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: MessageBubble(
                  isMe: message.username != widget.userId,
                  message: message,
                  image: widget.image,
                  fullName: (widget.firstname ?? '') + ' ' + (widget.lastname ?? ''),
                  isStory: widget.isStory,
                ),
              );
            },
          ),
        ),
        StreamBuilder<Map<int, double?>>(
          stream: _cubit.uploadProgress$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            final progressMap = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (progressMap.isNotEmpty) ...[
                    Row(
                      key: Key(progressMap.entries.length.toString()),
                      children: progressMap.entries.map((e) {
                        final newValue = e.value == 100.0 ? null : (e.value! / 100);

                        return Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: progressMap.entries.length == 1 ? 0.0 : 12.0),
                            child: LinearProgressIndicator(
                              minHeight: 1,
                              color: buttonColor,
                              value: newValue,
                              backgroundColor: messageBubble,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ],
              ),
            );
          },
        ),
        _buildSendMessage(),
      ],
    );
  }

  Widget _buildSendMessage() {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(left: 26.0, right: 26.0, bottom: 26.0),
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
            _buildTextField(),
            const SizedBox(width: 12.0),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (_cubit.uploadProgress.entries.length == 2) {
                  Fluttertoast.showToast(msg: 'Sıradakı şəkillərinizin yüklənməsini gözləyin.');
                } else {
                  _cubit.sendImage();
                }
              },
              child: Image.asset('assets/image_icon.png'),
            ),
            const SizedBox(width: 12.0),
            CupertinoButton(
              minSize: 0,
              padding: const EdgeInsets.all(8.0),
              onPressed: () {
                if (_messageEditingController.text.trim() != '') {
                  _cubit.sendMessage(
                    _messageEditingController.text,
                  );

                  _messageEditingController.clear();
                } else {
                  Fluttertoast.showToast(msg: 'Mesaj boş ola bilməz');
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
    );
  }

  Widget _buildTextField() {
    return Flexible(
      child: TextField(
        controller: _messageEditingController,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: 14.0,
            fontFamily: "Montserrat"
        ),
        decoration: const InputDecoration(
          prefix: SizedBox(width: 24.0),
          border: InputBorder.none,
          hintText: "İsmarıcınızı daxil edin...",
          hintStyle: TextStyle(
            fontSize: 14,
            color: textColorGrey,
            fontWeight: FontWeight.w500,
              fontFamily: "Montserrat"
          ),
        ),
      ),
    );
  }
}
