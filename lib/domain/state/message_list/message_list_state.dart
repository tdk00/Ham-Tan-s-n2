part of 'message_list_cubit.dart';

abstract class MessageListState extends Equatable {
  const MessageListState();

  @override
  List<Object> get props => [];
}

class MessageListInitial extends MessageListState {}

class MessageListLoading extends MessageListState {}

class MessageListFetched extends MessageListState {
  final List<MessageListModel> messages;

  const MessageListFetched({
    required this.messages,
  });

  @override
  List<Object> get props => [messages];
}

class MessageListAlert extends MessageListState {
  final String message;

  const MessageListAlert({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
