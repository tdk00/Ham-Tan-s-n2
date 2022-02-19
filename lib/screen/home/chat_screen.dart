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
  late final ChatCubit _cubit;

  final TextEditingController _messageEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit();
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

              return MessageBubble(
                isMe: message.username != widget.userId,
                message: message,
                image: widget.image,
                fullName: (widget.firstname ?? '') + ' ' + (widget.lastname ?? ''),
                isStory: widget.isStory,
              );
            },
          ),
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
                _cubit.sendMessage(
                  _messageEditingController.text,
                );

                _messageEditingController.clear();
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
        style: TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 14.0),
        decoration: InputDecoration(
          prefix: const SizedBox(width: 24.0),
          border: InputBorder.none,
          suffixIcon: CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            onPressed: () {
              _cubit.sendImage();
            },
            child: const Icon(
              Icons.image,
              color: Colors.black54,
            ),
          ),
          hintText: "İsmarıcınızı daxil edin...",
          hintStyle: const TextStyle(
            fontSize: 14,
            color: textColorGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
