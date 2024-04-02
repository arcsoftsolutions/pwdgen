import 'dart:math';

import 'password_component.dart';
import 'password_component_collection.dart';
import 'password_components.dart';
import 'password_constants.dart';

class PasswordGenerator {
  PasswordGenerator() {
    components.add(PasswordComponents.uppercase);
    components.add(PasswordComponents.lowercase);
    components.add(PasswordComponents.numbers);
  }

  int length = DEFAULT_PASSWORD_LENGTH;
  final PasswordComponentCollection components = PasswordComponentCollection();

  String generate() {
    _validate();
    return _createPassword();
  }

  void _validate() {
    if (components.isEmpty) {
      throw StateError('No password component was specified.');
    }
    if (length < MIN_PASSWORD_LENGTH || length > MAX_PASSWORD_LENGTH) {
      throw RangeError.range(length, MIN_PASSWORD_LENGTH, MAX_PASSWORD_LENGTH);
    }
  }

  String _createPassword() {
    String password = '';
    final Random random = Random();

    while (password.length < length) {
      final int componentIndex = random.nextInt(components.length);
      final PasswordComponent component = components.get(componentIndex);
      final int elementIndex = random.nextInt(component.length);
      password += component.get(elementIndex);
    }

    if (password.length > length) {
      password = password.substring(0, length);
    }

    return password;
  }
}
