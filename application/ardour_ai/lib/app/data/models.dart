import 'dart:convert';

class InvalidPassUserParameters extends Error {}

class PassUser {
  final String userName;
  final String userId;
  final String? profileImage;

  PassUser({required this.userId, required this.userName, this.profileImage});

  factory PassUser.fromJSON(data) {
    if (data['userId'] == null || data['userName'] == null) {
      throw InvalidPassUserParameters();
    }
    return PassUser(
      userId: data['userId']!,
      userName: data['userName']!,
      profileImage: data['profileImage'],
    );
  }

  String toJSON() {
    return jsonEncode({
      userId: userId,
      userName: userName,
      profileImage: profileImage,
    });
  }
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
