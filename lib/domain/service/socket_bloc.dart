import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketBloc {
  static final SocketBloc _socketBloc = SocketBloc._instance();

  factory SocketBloc() {
    return _socketBloc;
  }

  SocketBloc._instance();

  final String _baseUrl = 'ws://10.0.2.2:8000/ws';

  Future<void> connect(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final url = '$_baseUrl/$id/?token=$token';

    final channel = WebSocketChannel.connect(Uri.parse('wss://ws.ifelse.io/'));

    channel.stream.listen(
      (data) {
        log(data.toString());
      },
      onDone: () => print('Socket closed'),
      onError: (error) => log(error.toString()),
    );

    channel.sink.add('salam');
  }
}
