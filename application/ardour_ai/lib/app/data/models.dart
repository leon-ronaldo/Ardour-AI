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
