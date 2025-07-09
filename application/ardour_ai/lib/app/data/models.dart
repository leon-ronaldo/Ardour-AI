import 'dart:convert';

import 'package:ardour_ai/app/data/messages_models.dart';

class InvalidPassUserParameters extends Error {}

class PassUser {
  final String userName;
  final String userId;
  final String? profileImage;
  final int? followers;
  final int? following;

  PassUser({
    required this.userId,
    required this.userName,
    this.profileImage,
    this.followers,
    this.following,
  });

  String get followersStr => _formatCount(followers);
  String get followingStr => _formatCount(following);

  String _formatCount(int? count) {
    if (count == null) return "0";
    if (count >= 1000000000) {
      return "${(count / 1000000000).toStringAsFixed(count % 1000000000 >= 100000000 ? 1 : 0)}B";
    } else if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(count % 1000000 >= 100000 ? 1 : 0)}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(count % 1000 >= 100 ? 1 : 0)}k";
    }
    return count.toString();
  }

  factory PassUser.fromJSON(data) {
    if (data['userId'] == null || data['userName'] == null) {
      throw InvalidPassUserParameters();
    }
    return PassUser(
      userId: data['userId']!,
      userName: data['userName']!,
      profileImage: data['profileImage'],
      followers: data['followers'],
      following: data['following'],
    );
  }

  String toJSON() {
    return jsonEncode({
      userId: userId,
      userName: userName,
      profileImage: profileImage,
      followers: followers,
      following: following,
    });
  }

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "userName": userName,
    "profileImage": profileImage,
    "followers": followers,
    "following": following,
  };
}

class PostNotification {
  final String postId;
  final int timeStamp;

  PostNotification({required this.postId, required this.timeStamp});

  factory PostNotification.fromJson(Map<String, dynamic> json) {
    return PostNotification(
      postId: json['postId'],
      timeStamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'postId': postId, 'timeStamp': timeStamp};
  }

  /// Returns human-readable "time ago" (e.g., '5 minutes ago')
  String get timeAgo {
    final time = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}

class AccountReqNotification {
  final String userName;
  final String? profileImage;
  final String userId;
  final int timeStamp;

  AccountReqNotification({
    required this.userName,
    required this.userId,
    this.profileImage,
    required this.timeStamp,
  });

  factory AccountReqNotification.fromJson(Map<String, dynamic> json) {
    return AccountReqNotification(
      userId: json['userId'],
      userName: json['userName'],
      profileImage: json['profileImage'],
      timeStamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'profileImage': profileImage,
      'timeStamp': timeStamp,
    };
  }

  String get timeAgo {
    final time = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}

class ChatMessage {
  final String from;
  final String to;
  final String message;
  final int timestamp;
  final String? id;

  bool isRead;
  bool isLiveMessage;
  String? repliedTo;

  String senderName;

  ChatMessage({
    required this.from,
    required this.to,
    required this.message,
    required this.timestamp,
    this.senderName = "Username Not Set",
    this.isLiveMessage = false,
    this.isRead = false,
    this.repliedTo,
    this.id,
  });

  /// Factory to create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    print("chat mamae $json");
    return ChatMessage(
      from: json['from'],
      to: json['to'],
      message: json['message'],
      timestamp: json['timestamp'],
      isRead: json['isRead'] ?? false,
      isLiveMessage: json['isLiveMessage'] ?? false,
      repliedTo: json['repliedTo'],
      id: json['_id'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
      'isLiveMessage': isLiveMessage,
      if (repliedTo != null) 'repliedTo': repliedTo,
    };
  }

  /// Optional: Format timestamp to human-readable time
  String get formattedTime {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}

class PersonalChat {
  final String contactId;
  final List<ChatMessage> messages;

  PersonalChat({required this.contactId, required this.messages});

  /// Convert from JSON
  factory PersonalChat.fromJson(Map<String, dynamic> json) {
    return PersonalChat(
      contactId: json['contactId'],
      messages:
          (json['messages'] as List)
              .map((e) => ChatMessage.fromJson(e))
              .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'contactId': contactId,
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}

class ContactWithPreview {
  final PassUser contact;
  final List<ChatMessage>? recentMessages;

  ContactWithPreview({this.recentMessages, required this.contact});
}
