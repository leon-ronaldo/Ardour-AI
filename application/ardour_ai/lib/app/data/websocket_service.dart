// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';

import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String serverURL(token) => "ws://localhost:8055/?token=$token";
final String authenticationURL = "ws://localhost:8055/authenticate";
// const String token =
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODQxMzMwMmVkOTQxMmVjNWMwYWYzNjYiLCJlbWFpbCI6ImphbmUuc21pdGhAZXhhbXBsZS5jb20iLCJpYXQiOjE3NDkyMjQ0OTQsImV4cCI6MTc0OTMxMDg5NH0.QFN9l8zyNM2cRwSHHKRA4BbWscXMJ_u0PhUK54z0AOw";
// jane

class WSServiceNotInitializedError extends Error {}

class WebSocketService {
  WebSocketChannel? _channel;
  final _controller = StreamController<dynamic>.broadcast(); // broadcast stream
  StreamSubscription? _channelSubscription;

  bool get isConnected => _channel != null && _channel!.closeCode == null;

  Stream<dynamic> get stream => _controller.stream;

  Future<void> connect({
    String? url,
    String? token,
    void Function(int? code, String? reason)? serverCloseListener,
  }) async {
    if (_channel != null) await close();

    _channel = WebSocketChannel.connect(Uri.parse(url ?? serverURL(token)));

    _channelSubscription = _channel!.stream.listen(
      (data) => _controller.add(data),
      onError: (error) => _controller.addError(error),
      onDone: () {
        final code = _channel!.closeCode;
        final reason = _channel!.closeReason;
        print("WebSocket closed: code=$code, reason=$reason");
        serverCloseListener?.call(code, reason);
        _controller.close(); // close the broadcast controller
      },
      cancelOnError: true,
    );

    try {
      await _channel!.ready;
    } on Exception {
      throw WSServiceNotInitializedError();
    }
  }

  void addListener(void Function(dynamic data) onData) {
    stream.listen(onData); // Multiple listeners allowed
  }

  void send(WSBaseRequest data) {
    if (_channel != null)
      _channel!.sink.add(jsonEncode(data));
    else
      throw WSServiceNotInitializedError();
  }

  Future<void> close() async {
    await _channelSubscription?.cancel();
    await _channel?.sink.close();
    _channel = null;

    if (!_controller.isClosed) {
      await _controller.close();
    }
  }
}
