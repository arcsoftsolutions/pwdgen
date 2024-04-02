import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/domain/password_model.dart';

void main() {
  group('PasswordModel', () {
    final Map<String, dynamic> mock = <String, dynamic>{
      'password': 'password',
      'creation_date': 1711851815,
    };

    test('should create from json', () {
      final PasswordModel model = PasswordModel.fromJson(mock);
      expect(model.password, mock['password']);
      expect(model.creationDate.millisecondsSinceEpoch, mock['creation_date']);
    });

    test('should convert to json', () {
      final PasswordModel model = PasswordModel.fromJson(mock);
      final Map<String, dynamic> data = model.toJson();
      expect(mapEquals(mock, data), isTrue);
    });

    test('should get the password', () {
      final PasswordModel model = PasswordModel('password');
      expect(model.password, 'password');
      expect(model.toString(), 'password');
    });

    test('should get the hash code', () {
      const String password = 'password';
      final PasswordModel model = PasswordModel(password);
      expect(model.hashCode, equals(password.hashCode));
    });

    test('passwords should be equal', () {
      final PasswordModel model1 = PasswordModel('password');
      final PasswordModel model2 = PasswordModel('password');
      expect(model1, equals(model2));
    });

    test('passwords should not be equal', () {
      final PasswordModel model1 = PasswordModel('password1');
      final PasswordModel model2 = PasswordModel('password2');
      expect(model1, isNot(equals(model2)));
    });
  });
}
