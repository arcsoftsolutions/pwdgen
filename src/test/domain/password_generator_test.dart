import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/domain/password_component_collection.dart';
import 'package:pwdgen/domain/password_components.dart';
import 'package:pwdgen/domain/password_generator.dart';

void main() {
  group('PasswordGenerator', () {
    late PasswordGenerator generator;

    setUp(() {
      generator = PasswordGenerator();
    });

    test('should have the default property values', () {
      expect(generator.length, 12);
      expect(generator.components.length, 3);

      final PasswordComponentCollection components = generator.components;
      expect(components.contains(PasswordComponents.uppercase), true);
      expect(components.contains(PasswordComponents.lowercase), true);
      expect(components.contains(PasswordComponents.numbers), true);
    });

    test('should throw a StateError when no password component is specified',
        () {
      generator.components.clear();
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
      generator.components.clear();
      generator.components.add(PasswordComponents.numbers);
      final String password = generator.generate();
      final RegExp pattern = RegExp(r'^[0-9]+$');
      expect(pattern.hasMatch(password), true);
    });

    test('should generate a password with lowercase only', () {
      generator.components.clear();
      generator.components.add(PasswordComponents.lowercase);
      final String password = generator.generate();
      final RegExp pattern = RegExp(r'^[a-z]+$');
      expect(pattern.hasMatch(password), true);
    });

    test('should generate a password with uppercase only', () {
      generator.components.clear();
      generator.components.add(PasswordComponents.uppercase);
      final String password = generator.generate();
      final RegExp pattern = RegExp(r'^[A-Z]+$');
      expect(pattern.hasMatch(password), true);
    });

    test('should generate a password with symbols only', () {
      generator.components.clear();
      generator.components.add(PasswordComponents.symbols);
      final String password = generator.generate();
      final RegExp pattern = RegExp(r'^[*!@#$%&]+$');
      expect(pattern.hasMatch(password), true);
    });

    test('should generate a password with words only', () {
      generator.components.clear();
      generator.components.add(PasswordComponents.words);
      final String password = generator.generate();
      final RegExp pattern = RegExp(r'^[A-z]+$');
      expect(pattern.hasMatch(password), true);
    });
  });
}
