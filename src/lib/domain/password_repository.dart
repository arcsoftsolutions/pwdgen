import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'password_model.dart';

class PasswordRepository {
  PasswordRepository(this._storage);

  static const String STORAGE_KEY = 'passwords';
  final FlutterSecureStorage _storage;

  Future<void> add(PasswordModel password) async {
    final List<PasswordModel> passwords = await _readPasswords();
    if (!passwords.contains(password)) {
      passwords.add(password);
      await _writePasswords(passwords);
    }
  }

  Future<void> remove(PasswordModel password) async {
    final List<PasswordModel> passwords = await _readPasswords();
    if (passwords.remove(password)) {
      await _writePasswords(passwords);
    }
  }

  Future<List<PasswordModel>> findAll() {
    return _readPasswords();
  }

  Future<List<PasswordModel>> _readPasswords() async {
    final String? data = await _storage.read(key: STORAGE_KEY);
    if (data == null || data.isEmpty) {
      return List<PasswordModel>.empty(growable: true);
    }

    return List<PasswordModel>.from(
      jsonDecode(
        data,
        reviver: (Object? key, Object? value) {
          if (value is Map<String, dynamic>) {
            return PasswordModel.fromJson(value);
          }
          return value;
        },
      ) as List<dynamic>,
    );
  }

  Future<void> _writePasswords(List<PasswordModel> passwords) async {
    final String encodedData = jsonEncode(passwords);
    await _storage.write(key: STORAGE_KEY, value: encodedData);
  }
}
