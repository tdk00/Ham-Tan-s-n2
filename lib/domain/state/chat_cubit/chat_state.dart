part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatFetched extends ChatState {
  final List<ReceivedMessageModel> messages;

  const ChatFetched({
    required this.messages,
  });

  @override
  List<Object> get props => [messages];

  ChatFetched copyWith({
    List<ReceivedMessageModel>? messages,
  }) {
    return ChatFetched(
      messages: messages ?? this.messages,
    );
  }
}

class ChatAlert extends ChatState {
  final String message;

  const ChatAlert({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
