import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageServices {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String CONTACTS = "CONTACTS";
  static const String LAST_DATE_OF_FETCHED_CONTACTS = "LAST_FETCHED_CONTACTS";
  static const String PERSONAL_CHATS = "PERSONAL_CHATS";

  List<PassUser> contacts = [];

  Future<DateTime?> get lastDateOfFetchedContacts async => DateTime.tryParse(
    await _storage.read(key: LAST_DATE_OF_FETCHED_CONTACTS) ?? "",
  );

  void writeContacts(dynamic input) async {
    if (input is List) {
      contacts = input.map((item) => PassUser.fromJSON(item)).toList();
      await _storage.write(
        key: CONTACTS,
        value: jsonEncode(contacts.map((contact) => contact.toMap()).toList()),
      );

      await _storage.write(
        key: LAST_DATE_OF_FETCHED_CONTACTS,
        value: DateTime.now().toIso8601String(),
      );
    } else if (input is String) {
      contacts = jsonDecode(input);
      await _storage.write(key: CONTACTS, value: input);

      await _storage.write(
        key: LAST_DATE_OF_FETCHED_CONTACTS,
        value: DateTime.now().toIso8601String(),
      );
    } else {
      throw ArgumentError(
        'Invalid type for writeContacts: ${input.runtimeType}',
      );
    }
  }

  Future<List<PassUser>> readContacts() async {
    contacts =
        (jsonDecode((await _storage.read(key: CONTACTS)) ?? "[]") as List)
            .map((item) => PassUser.fromJSON(item))
            .toList();

    return contacts;
  }

  Future<void> writePersonalChat(PersonalChat newChat) async {
    final jsonString = await _storage.read(key: PERSONAL_CHATS);

    List<PersonalChat> allChats = [];

    if (jsonString != null && jsonString.isNotEmpty) {
      final decoded = jsonDecode(jsonString);
      allChats =
          (decoded as List).map((e) => PersonalChat.fromJson(e)).toList();
    }

    final existingIndex = allChats.indexWhere(
      (chat) => chat.contactId == newChat.contactId,
    );

    if (existingIndex != -1) {
      allChats[existingIndex] = newChat;
    } else {
      allChats.add(newChat);
    }

    final updatedJson = jsonEncode(allChats.map((e) => e.toJson()).toList());
    await _storage.write(key: PERSONAL_CHATS, value: updatedJson);
  }

  Future<List<PersonalChat>> readAllPersonalChats() async {
    final jsonString = await _storage.read(key: PERSONAL_CHATS);

    if (jsonString == null || jsonString.isEmpty) return [];

    final decoded = jsonDecode(jsonString);
    return (decoded as List).map((e) => PersonalChat.fromJson(e)).toList();
  }

  Future<PersonalChat?> readPersonalChat(String contactId) async {
    final jsonString = await _storage.read(key: PERSONAL_CHATS);

    if (jsonString == null || jsonString.isEmpty) return null;

    final decoded = jsonDecode(jsonString);
    final allChats =
        (decoded as List).map((e) => PersonalChat.fromJson(e)).toList();

    try {
      return allChats.firstWhere((chat) => chat.contactId == contactId);
    } catch (e) {
      return null;
    }
  }
}
