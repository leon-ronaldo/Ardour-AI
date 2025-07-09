// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final String baseURI = "wss://ardour-ai.onrender.com";
String serverURL(token) => "$baseURI/?token=$token";
final String authenticationURL = "$baseURI/authenticate";
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

  Future<bool> safeCheck() async {
    if (_channel != null) {
      try {
        await _channel?.ready;
        return true;
      } on SocketException catch (_) {
        print("athu ready agala paaa");
        return false;
      } on WebSocketChannelException catch (_) {
        print("athu ready agala paaa");
        return false;
      }
    } else {
      return false;
    }
  }

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

    await safeCheck();
  }

  Future<void> addListener(void Function(dynamic data) onData) async {
    if (await safeCheck()) stream.listen(onData);
  }

  Future<void> send(WSBaseRequest data) async {
    if (await safeCheck()) {
      _channel!.sink.add(jsonEncode(data));
    }
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
