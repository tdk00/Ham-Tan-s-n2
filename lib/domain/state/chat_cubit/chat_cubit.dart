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
import 'package:rxdart/rxdart.dart';
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
  int _key = 0;

  final BehaviorSubject<Map<int, double?>> _uploadProgressController = BehaviorSubject<Map<int, double?>>.seeded({});

  Stream<Map<int, double?>> get uploadProgress$ => _uploadProgressController.stream;

  Map<int, double?> get uploadProgress => _uploadProgressController.value;

  void updateUploadProgress(int key, double? value) {
    final updatedUploadProgress = uploadProgress;

    updatedUploadProgress[key] = value;

    _uploadProgressController.add(updatedUploadProgress);
  }

  @override
  Future<void> close() {
    _socketChannel?.sink.close();
    _uploadProgressController.close();
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
          sender: int.tryParse(message.sender!),
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

    log('Socket url $url');

    _socketChannel = WebSocketChannel.connect(Uri.parse(url));
  }

  void listenMessage() {
    _socketChannel?.stream.listen(
      (data) {
        final remoteMessage = ReceivedMessageModel.fromJson(jsonDecode(data));

        log('Socket data $data');

        final previousState = state as ChatFetched;
        final messages = previousState.messages;

        final imageMessage = remoteMessage.image == '' ? null : remoteMessage.image;
        final statusImage = remoteMessage.statusImage == '' ? null : remoteMessage.statusImage;

        final message = ReceivedMessageModel(
          message: remoteMessage.message,
          sender: remoteMessage.sender,
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
    final prefs = await SharedPreferences.getInstance();
    final myUserId = prefs.getString('user_id');
    final myId = int.tryParse(myUserId!);

    log('stsImage: $statusImage,stsId: $statusId, ${(statusId == null && _storyImage == null)} text: $text, image: $image');

    if (statusId != null) {
      _storyImage = null;
      await _fetchStoryImages(statusId);

      _socketChannel?.sink.add(
        json.encode(
          {
            'message': text,
            'sender': myId,
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
            'sender': myId,
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

      log('Get messages ${result.body}');

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
    int currentKey = 0;

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

      ++_key;

      currentKey = _key;

      final result = await dio.post(
        endpoint,
        data: formData,
        onSendProgress: (int sent, int total) {
          final progress = sent / total * 100;

          updateUploadProgress(currentKey, progress);
        },
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      final imageUrl = result.data['imagex'];

      log('IMG $imageUrl');

      if (imageUrl != null) {
        _pickedImage = null;

        try {
          await Future.delayed(const Duration(milliseconds: 1000));

          final imgResult = await dio.get(
            imageUrl,
            options: Options(
              validateStatus: (status) {
                return true;
              },
            ),
          );

          if (imgResult.statusCode == 404) {
            await Future.delayed(const Duration(milliseconds: 1500)).then(
              (value) async => await sendMessage('', image: imageUrl),
            );
          } else {
            await sendMessage('', image: imageUrl);
          }
        } catch (e) {
          log(e.toString() + 'imageUrl');
        }
      } else {
        throw Exception('X??ta ba?? verdi');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      final updatedUploadProgress = uploadProgress..removeWhere((key, value) => key == currentKey);

      _uploadProgressController.add(updatedUploadProgress);
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

      log('StoryImages ${result.body}');
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
