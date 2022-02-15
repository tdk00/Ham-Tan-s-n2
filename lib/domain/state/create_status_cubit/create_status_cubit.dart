import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everyone_know_app/domain/model/status.dart';
import 'package:everyone_know_app/domain/repository/create_user.repo.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('user_id') ?? '';

      if (pickedImage == null && (text == null || text == '')) {
        emit(const CreateStatusError('Status boş ola bilməz'));
      } else if (pickedImage == null) {
        statusModel = (await repository.createUserStatusRepository(id, '$text'))!;

        emit(CreateStatusLoaded(statusModel));
        Logger().i("Status Cubit Initazlized : " + statusModel.user.toString());
      } else if (text == null) {
        statusModel = (await repository.createUserStatusRepository(id, '', imgUrl: pickedImage))!;

        emit(CreateStatusLoaded(statusModel));
        Logger().i("Status Cubit Initazlized : " + statusModel.user.toString());
      } else {
        statusModel = (await repository.createUserStatusRepository(id, '$text', imgUrl: pickedImage))!;

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

      //   final compressedImage = await _compressImage(File(pickedImage.path), 70);

      updatePickedImage(File(pickedImage.path));
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
}
