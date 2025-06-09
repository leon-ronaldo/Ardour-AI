// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String serverURL(token) => "ws://10.0.2.2:8055/?token=$token";
final String authenticationURL = "ws://10.0.2.2:8055/authenticate";
// const String token =
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODQxMzMwMmVkOTQxMmVjNWMwYWYzNjYiLCJlbWFpbCI6ImphbmUuc21pdGhAZXhhbXBsZS5jb20iLCJpYXQiOjE3NDkyMjQ0OTQsImV4cCI6MTc0OTMxMDg5NH0.QFN9l8zyNM2cRwSHHKRA4BbWscXMJ_u0PhUK54z0AOw";
// jane

class WSServiceNotInitializedError extends Error {}

class WebSocketService {
  WebSocketChannel? _channel;
  bool get isConnected => _channel != null && _channel!.closeCode == null;

  void connect({String? url, String? token}) {
    _channel = WebSocketChannel.connect(Uri.parse(url ?? serverURL(token)));
  }

  void addEventListeners(
    void Function(dynamic) dataListener, {
    void Function(dynamic)? errorListener,
    void Function(int? code, String? reason)? serverCloseListener,
  }) {
    if (_channel != null)
      _channel!.stream.listen(
        dataListener,
        onError: errorListener,
        onDone: () {
          if (serverCloseListener == null) return;
          if (_channel == null) throw WSServiceNotInitializedError();
          serverCloseListener(_channel!.closeCode, _channel!.closeReason);
        },
      );
    else
      throw WSServiceNotInitializedError();
  }

  void send(WSBaseRequest data) {
    if (_channel != null)
      _channel!.sink.add(jsonEncode(data));
    else
      throw WSServiceNotInitializedError();
  }

  Future<void> close() async {
    if (_channel == null) {
      throw WSServiceNotInitializedError();
    }
    await _channel!.sink.close();
    _channel = null;
  }
}
