import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:everyone_know_app/domain/model/status.dart';
import 'package:everyone_know_app/domain/repository/create_user.repo.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

part 'create_status_state.dart';

class CreateStatusCubit extends Cubit<CreateStatusState> {
  CreateStatusCubit(this.repository) : super(CreateStatusInitial());

  final CreateUserRepository repository;

  UserCreateStatus statusModel = UserCreateStatus();

  final BehaviorSubject<File?> _pickedImageController = BehaviorSubject<File?>();
  final BehaviorSubject<String?> _textController = BehaviorSubject<String?>();

  Stream<File?> get pickedImage$ => _pickedImageController.stream;
  Stream<String?> get text$ => _textController.stream;

  File? get pickedImage => _pickedImageController.valueOrNull;
  String? get text => _textController.valueOrNull;

  void updatePickedImage(File? value) => _pickedImageController.add(value);
  void updateText(String? value) => _textController.add(value);

  @override
  Future<void> close() {
    _pickedImageController.close();
    _textController.close();
    return super.close();
  }

  Future<void> createStatusCubit() async {
    try {
      emit(CreateStatusLoading());

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final token = prefs.getString('token');

      log(token.toString() + '-' + userId.toString());

      if (pickedImage == null && (text == null || text == '')) {
        emit(const CreateStatusError('Status boş ola bilməz'));
      } else if (pickedImage == null) {
        emit(const CreateStatusError('Status boş ola bilməz'));
        Logger().i("Status Cubit Initazlized : " + statusModel.user.toString());
      } else if (text == null) {
        statusModel = (await repository.createUserStatusRepository(userId, token, '', imgUrl: pickedImage))!;

        emit(CreateStatusLoaded(statusModel));
        Logger().i("Status Cubit Initazlized : " + statusModel.user.toString());
      } else {
        statusModel = (await repository.createUserStatusRepository(userId, token, '$text', imgUrl: pickedImage))!;

        emit(CreateStatusLoaded(statusModel));
        Logger().i("Status Cubit Initazlized : " + statusModel.user.toString());
      }
    } catch (e) {
      Logger().e("Status Cubit Error : " + e.toString());

      emit(CreateStatusError(e.toString()));
    }
  }

  Future<void> chooseImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedImage == null) return;

      final compressedImage = await _compressImage(File(pickedImage.path), 70);

      if (compressedImage == null) return;

      updatePickedImage(compressedImage);
    } catch (e) {
      emit(CreateStatusError(e.toString()));
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

  Future<UserCreateStatus> createStory(
    String storyText, {
    File? imgUrl,
  }) async {
    try {
      final dio = Dio();
      const endpoint = 'https://hamitanisin.digital/api/chat/image/';

      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getString('user_id');
      final token = prefs.getString('token');

      final myId = int.tryParse(myUserId!);

      final formData = FormData.fromMap({
        'text': storyText,
        'user': myId,
        if (imgUrl != null)
          'image': await MultipartFile.fromFile(
            imgUrl.path,
            filename: basename(imgUrl.path),
          )
      });

      final result = await dio.post(
        endpoint,
        data: formData,
        onSendProgress: (int sent, int total) {
          final progress = sent / total * 100;
        },
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      if (result.statusCode == 201) {
        return UserCreateStatus.fromJson(result.data!);
      } else {
        throw Exception('Bilinməyən xəta baş verdi');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
