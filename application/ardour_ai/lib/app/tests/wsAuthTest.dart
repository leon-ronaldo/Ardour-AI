import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

String serverURL(token) => "ws://localhost:8055/?token=$token";
final String authenticationURL = "ws://localhost:8055/authenticate";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODQxMzMwMmVkOTQxMmVjNWMwYWYzNjYiLCJlbWFpbCI6ImphbmUuc21pdGhAZXhhbXBsZS5jb20iLCJpYXQiOjE3NDkyMjQ0OTQsImV4cCI6MTc0OTMxMDg5NH0.QFN9l8zyNM2cRwSHHKRA4BbWscXMJ_u0PhUK54z0AOw";

Future<void> main() async {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse(serverURL(token)),
  );

  _channel.stream.listen(
    (data) {
      final decoded = jsonDecode(data);
      if (decoded['message'] != null) {
        if (decoded['code'] == 4003) {
          print("server declined us");
        }
      }
    },
    onDone: () {
      print(
        "server closed us with code: ${_channel.closeCode}, and reason: ${_channel.closeReason}",
      );
    },
  );

  try {
    await _channel.ready;
  } on Exception catch (e) {
    print("some error occured while connecting to server $e");
  }
}
