import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageServices {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String CONTACTS = "CONTACTS";
  static const String LAST_DATE_OF_FETCHED_CONTACTS = "LAST_FETCHED_CONTACTS";

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
}
