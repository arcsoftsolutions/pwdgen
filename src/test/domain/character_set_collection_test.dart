import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/domain/character_set.dart';
import 'package:pwdgen/domain/character_set_collection.dart';

void main() {
  group('CharacterSetCollection', () {
    late CharacterSetCollection collection;

    setUp(() {
      collection = CharacterSetCollection();
    });

    test('should be empty', () {
      expect(collection.length, 0);
      expect(collection.isEmpty, true);
      expect(collection.isNotEmpty, false);
    });

    test('should not be empty', () {
      collection.add(CharacterSet.uppercase);
      expect(collection.length, 1);
      expect(collection.isEmpty, false);
      expect(collection.isNotEmpty, true);
    });

    test('should add the character set', () {
      collection.add(CharacterSet.uppercase);
      expect(collection.contains(CharacterSet.uppercase), true);
    });

    test('should get the character set', () {
      collection.add(CharacterSet.uppercase);
      expect(collection.get(0), CharacterSet.uppercase);
    });

    test('should remove the character set', () {
      collection.add(CharacterSet.uppercase);
      collection.remove(CharacterSet.uppercase);
      expect(collection.contains(CharacterSet.uppercase), false);
    });

    test('should remove all character sets', () {
      collection.add(CharacterSet.uppercase);
      collection.add(CharacterSet.lowercase);
      collection.clear();
      expect(collection.isEmpty, true);
    });
  });
}
