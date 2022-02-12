import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everyone_know_app/domain/model/status.dart';
import 'package:everyone_know_app/domain/repository/create_user.repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

part 'create_status_state.dart';

class CreateStatusCubit extends Cubit<CreateStatusState> {
  CreateStatusCubit(this.repository) : super(CreateStatusInitial());
  final CreateUserRepository repository;

  UserCreateStatus statusModel = UserCreateStatus();
  final ImagePicker imagePicker = ImagePicker();

  void createStatusCubit(String id, File image) async {
    try {
      emit(CreateStatusLoading());
      statusModel = (await repository.createUserStatusRepository(id, '',
          imgUrl: image))!;
      Logger().i("Status Cubit Initazlized : " + statusModel.user.toString());
      emit(CreateStatusLoaded(statusModel));
    } catch (e) {
      Logger().e("Status Cubit Error : "+e.toString());
      emit(CreateStatusError(e.toString()));
    }
  }

  Future<void> chooseImage() async {
    try {
      emit(CreateStatusLoading());

      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if(pickedImage == null) {
        emit(CreateStatusImageNotSelected());
      }
      
      emit(CreateStatusImageSelected(image: File(pickedImage!.path)));

    } catch (e) {
      emit(CreateStatusError(e.toString()));
    }
  }
}
