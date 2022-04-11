import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketBloc {
  static final SocketBloc _socketBloc = SocketBloc._instance();

  factory SocketBloc() {
    return _socketBloc;
  }

  SocketBloc._instance();

  final String _baseUrl = 'wss://hamitanisin.digital/ws';

  // wss://hamitanisin.digital/ws/1/?token=5360bd68d8b31cfe716111189e336e4b0fb38c3b

  Future<void> connect(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    log('${prefs.getString('user_id')}');

    final url = '$_baseUrl/$id/?token=$token';

    final channel = WebSocketChannel.connect(Uri.parse(url));

    channel.stream.listen(
      (data) {
        log('Socket connect $data');
      },
      onDone: () => print('Socket closed'),
      onError: (error) => log(error.toString()),
    );
  }
}
