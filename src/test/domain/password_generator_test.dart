import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/domain/character_set.dart';
import 'package:pwdgen/domain/password_generator.dart';

void main() {
  group('PasswordGenerator', () {
    late PasswordGenerator generator;

    setUp(() {
      generator = PasswordGenerator();
    });

    test('should have the default property values', () {
      expect(generator.length, 12);
      expect(generator.characters.length, 3);
      expect(generator.characters.contains(CharacterSet.uppercase), true);
      expect(generator.characters.contains(CharacterSet.lowercase), true);
      expect(generator.characters.contains(CharacterSet.numbers), true);
    });

    test('should throw a StateError when no character set is specified', () {
      generator.characters.clear();
      expect(
        () => generator.generate(),
        throwsA(const TypeMatcher<StateError>()),
      );
    });

    test('should throw a RangeError when an invalid length is specified', () {
      final Matcher matcher = throwsA(const TypeMatcher<RangeError>());
      generator.length = 0;
      expect(() => generator.generate(), matcher);
      generator.length = 51;
      expect(() => generator.generate(), matcher);
    });

    test('should generate a password with defined length', () {
      final String password = generator.generate();
      expect(password.length, generator.length);
    });

    test('should generate a password with numbers only', () {
      generator.characters.clear();
      generator.characters.add(CharacterSet.numbers);
      final String password = generator.generate();
      expect(CharacterSet.numbers.match(password), true);
    });

    test('should generate a password with lowercase only', () {
      generator.characters.clear();
      generator.characters.add(CharacterSet.lowercase);
      final String password = generator.generate();
      expect(CharacterSet.lowercase.match(password), true);
    });

    test('should generate a password with uppercase only', () {
      generator.characters.clear();
      generator.characters.add(CharacterSet.uppercase);
      final String password = generator.generate();
      expect(CharacterSet.uppercase.match(password), true);
    });

    test('should generate a password with symbols only', () {
      generator.characters.clear();
      generator.characters.add(CharacterSet.symbols);
      final String password = generator.generate();
      expect(CharacterSet.symbols.match(password), true);
    });
  });
}
