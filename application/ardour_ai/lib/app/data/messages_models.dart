class IChatMessage {
  final String from;
  final String to;
  final String message;
  final int timestamp;

  IChatMessage({
    required this.from,
    required this.to,
    required this.message,
    required this.timestamp,
  });

  factory IChatMessage.fromJson(Map<String, dynamic> json) => IChatMessage(
    from: json['from'],
    to: json['to'],
    message: json['message'],
    timestamp: json['timestamp'],
  );

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'message': message,
    'timestamp': timestamp,
  };
}

class IGroupChatMessage {
  final String from;
  final String groupId;
  final String message;
  final int timestamp;

  IGroupChatMessage({
    required this.from,
    required this.groupId,
    required this.message,
    required this.timestamp,
  });

  factory IGroupChatMessage.fromJson(Map<String, dynamic> json) =>
      IGroupChatMessage(
        from: json['from'],
        groupId: json['groupId'],
        message: json['message'],
        timestamp: json['timestamp'],
      );

  Map<String, dynamic> toJson() => {
    'from': from,
    'groupId': groupId,
    'message': message,
    'timestamp': timestamp,
  };
}
