import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/domain/password_component_collection.dart';
import 'package:pwdgen/domain/password_components.dart';

void main() {
  group('PasswordComponentCollection', () {
    late PasswordComponentCollection collection;

    setUp(() {
      collection = PasswordComponentCollection();
    });

    test('should be empty', () {
      expect(collection.length, 0);
      expect(collection.isEmpty, true);
      expect(collection.isNotEmpty, false);
    });

    test('should not be empty', () {
      collection.add(PasswordComponents.uppercase);
      expect(collection.length, 1);
      expect(collection.isEmpty, false);
      expect(collection.isNotEmpty, true);
    });

    test('should add the password component', () {
      collection.add(PasswordComponents.uppercase);
      expect(collection.contains(PasswordComponents.uppercase), true);
    });

    test('should get the password component', () {
      collection.add(PasswordComponents.uppercase);
      expect(collection.get(0), PasswordComponents.uppercase);
    });

    test('should remove the password component', () {
      collection.add(PasswordComponents.uppercase);
      collection.remove(PasswordComponents.uppercase);
      expect(collection.contains(PasswordComponents.uppercase), false);
    });

    test('should remove all password components', () {
      collection.add(PasswordComponents.uppercase);
      collection.add(PasswordComponents.lowercase);
      collection.clear();
      expect(collection.isEmpty, true);
    });
  });
}
