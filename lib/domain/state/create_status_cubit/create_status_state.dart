part of 'create_status_cubit.dart';

abstract class CreateStatusState extends Equatable {
  const CreateStatusState();

  @override
  List<Object> get props => [];
}

class CreateStatusInitial extends CreateStatusState {}

class CreateStatusLoading extends CreateStatusState {}

class CreateStatusImageNotSelected extends CreateStatusState {}

class CreateStatusImageSelected extends CreateStatusState {
  final File image;

  const CreateStatusImageSelected({
    required this.image,
  });

  @override
  List<Object> get props => [image];
}

class CreateStatusLoaded extends CreateStatusState {
  final UserCreateStatus createStatus;

  const CreateStatusLoaded(this.createStatus);

  @override
  List<Object> get props => [createStatus];
}

class CreateStatusError extends CreateStatusState {
  final String? error;

  const CreateStatusError(this.error);
}
