import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everyone_know_app/domain/model/chat_messages_model.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  WebSocketChannel? _socketChannel;

  final String _baseUrl = 'wss://hamitanisin.digital/ws';
  String userId = '';
  String token = '';

  @override
  Future<void> close() {
    _socketChannel?.sink.close();
    return super.close();
  }

  Future<void> init(String id) async {
    try {
      userId = id;

      emit(ChatLoading());

      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token')!;

      final result = await getMessages();

      final messages = <ReceivedMessageModel>[];

      for (final message in result) {
        final messageModel = ReceivedMessageModel(
          message: message.message,
          username: int.tryParse(message.sender!),
          image: message.image,
        );

        messages.add(messageModel);
      }

      emit(ChatFetched(
        messages: messages,
      ));

      _connect();
    } catch (e) {
      emit(ChatAlert(message: e.toString()));
    } finally {
      listenMessage();
    }
  }

  void _connect() {
    final url = '$_baseUrl/$userId/?token=$token';

    log(url);

    _socketChannel = WebSocketChannel.connect(Uri.parse(url));
  }

  void listenMessage() {
    _socketChannel?.stream.listen(
      (data) {
        final remoteMessage = ReceivedMessageModel.fromJson(jsonDecode(data));

        final previousState = state as ChatFetched;
        final messages = previousState.messages;

        final imageMessage = remoteMessage.image == '' ? null : remoteMessage.image;

        final message = ReceivedMessageModel(
          message: remoteMessage.message,
          username: remoteMessage.username,
          image: imageMessage,
        );

        final updatedMessages = [message, ...messages];

        emit(ChatLoading());
        emit(previousState.copyWith(messages: updatedMessages));
      },
    ).onError((e) {
      print(e.toString());

      _connect();
    });
  }

  void sendMessage(String text) {
    _socketChannel?.sink.add(
      json.encode(
        {
          'message': text,
          'image': '',
        },
      ),
    );
  }

  Future<List<ChatMessagesModel>> getMessages() async {
    try {
      const endpoint = 'https://hamitanisin.digital/api/chat/messages';

      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getString('user_id');
      final token = prefs.getString('token');

      final myId = int.tryParse(myUserId!);
      final receiverId = int.tryParse(userId);

      final chatId = myId! > receiverId! ? '$myId-$receiverId' : '$receiverId-$myId';

      final result = await http.get(
        Uri.parse('$endpoint/$chatId'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      return chatMessagesModelFromJson(result.body);
    } catch (e) {
      throw Exception(e);
    }
  }
}
