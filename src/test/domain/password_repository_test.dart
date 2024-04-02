import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/domain/password_model.dart';
import 'package:pwdgen/domain/password_repository.dart';

void main() {
  group('PasswordRepository', () {
    final PasswordModel mockPassword1 = PasswordModel('password1');
    final PasswordModel mockPassword2 = PasswordModel('password2');
    final PasswordModel mockPassword3 = PasswordModel('password3');

    final List<PasswordModel> mockPasswords = <PasswordModel>[
      mockPassword2,
      mockPassword3
    ];

    late FlutterSecureStorage storage;
    late PasswordRepository repository;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues(
        <String, String>{'passwords': jsonEncode(mockPasswords)},
      );

      storage = const FlutterSecureStorage();
      repository = PasswordRepository(storage);
    });

    test('should add the password', () async {
      await repository.add(mockPassword1);
      expect(await repository.findAll(), contains(mockPassword1));
    });

    test('should not add duplicate passwords', () async {
      await repository.add(mockPassword2);
      expect(await repository.findAll(), hasLength(2));
    });

    test('should remove the password', () async {
      await repository.remove(mockPassword2);
      expect(await repository.findAll(), isNot(contains(mockPassword2)));
    });

    test('should find all passwords', () async {
      final List<PasswordModel> passwords = await repository.findAll();
      expect(listEquals(passwords, mockPasswords), isTrue);
    });

    test('should return an empty list when there is no data', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      final List<PasswordModel> passwords = await repository.findAll();
      expect(passwords, isEmpty);
    });
  });
}
