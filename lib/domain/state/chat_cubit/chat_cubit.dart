import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:everyone_know_app/domain/model/chat_messages_model.dart';
import 'package:everyone_know_app/domain/model/received_message_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  WebSocketChannel? _socketChannel;

  final String _baseUrl = 'wss://hamitanisin.digital/ws';
  String userId = '';
  String token = '';
  String? _pickedImage = '';
  String? _storyImage = '';

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
          statusImage: message.statusImage,
        );

        messages.add(messageModel);
      }

      emit(ChatFetched(
        messages: messages.reversed.toList(),
      ));

      _connect();
    } catch (e) {
      emit(ChatAlert(message: e.toString()));
    } finally {
      listenMessage();
      await readMessages();
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
        final statusImage = remoteMessage.statusImage == '' ? null : remoteMessage.statusImage;

        final message = ReceivedMessageModel(
          message: remoteMessage.message,
          username: remoteMessage.username,
          image: imageMessage,
          statusId: remoteMessage.statusId,
          statusImage: statusImage,
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

  Future<void> sendMessage(
    String text, {
    String? image,
    String? statusImage,
    String? statusId,
  }) async {
    log('$statusImage, $statusId, ${(statusId == null && _storyImage == null)}');

    if (statusId != null) {
      _storyImage = null;
      await _fetchStoryImages(statusId);

      _socketChannel?.sink.add(
        json.encode(
          {
            'message': text,
            'image': image ?? '',
            'status_id': statusId,
            'status_image': _storyImage ?? '',
          },
        ),
      );
    } else {
      _socketChannel?.sink.add(
        json.encode(
          {
            'message': text,
            'image': image ?? '',
            'status_id': '',
            'status_image': '',
          },
        ),
      );
    }
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

      log(result.body.toString());

      return chatMessagesModelFromJson(result.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> readMessages() async {
    const endpoint = 'https://hamitanisin.digital/api/chat/messages/read';

    final prefs = await SharedPreferences.getInstance();
    final myUserId = prefs.getString('user_id');
    final token = prefs.getString('token');

    final myId = int.tryParse(myUserId!);
    final receiverId = int.tryParse(userId);

    final chatId = myId! > receiverId! ? '$myId-$receiverId' : '$receiverId-$myId';

    final body = {
      "thread": chatId,
    };

    await http.patch(
      Uri.parse('$endpoint/$chatId/'),
      headers: {
        'Authorization': 'Token $token',
      },
      body: body,
    );
  }

  Future<void> sendImage() async {
    try {
      await _chooseImage();

      final dio = Dio();
      const endpoint = 'https://hamitanisin.digital/api/chat/image/';

      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getString('user_id');
      final token = prefs.getString('token');

      final myId = int.tryParse(myUserId!);
      final receiverId = int.tryParse(userId);

      final chatId = myId! > receiverId! ? '$myId-$receiverId' : '$receiverId-$myId';

      final formData = FormData.fromMap({
        // 'sender': myUserId,
        'receiver': userId,
        'thread_name': chatId,
        // 'is_read': false,
        if (_pickedImage != null)
          'image': await MultipartFile.fromFile(
            _pickedImage!,
            filename: basename(_pickedImage!),
          )
      });

      final result = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      log(result.data['imagex'].toString());

      if (result.data['imagex'] != null) {
        _pickedImage = null;
        await sendMessage('', image: result.data['imagex']);
      } else {
        throw Exception('Xəta baş verdi');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _fetchStoryImages(String id) async {
    try {
      final endpoint = 'https://hamitanisin.digital/api/status/url/$id/';

      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getString('user_id');
      final token = prefs.getString('token');

      final result = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Token $token',
        },
      );
      final response = jsonDecode(result.body);

      _storyImage = response['image'];

      log(result.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _chooseImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedImage == null) return;

      final compressedImage = await _compressImage(File(pickedImage.path), 70);

      _pickedImage = compressedImage?.path;
    } catch (e) {
      emit(ChatAlert(message: e.toString()));
    }
  }

  Future<File?> _compressImage(File file, int quality) async {
    final directory = await getTemporaryDirectory();
    final path = directory.absolute.path;
    final targetPath = path + file.path.split('/').last;

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );

    return result;
  }
}
