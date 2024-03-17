import 'dart:math';

import 'character_set.dart';
import 'character_set_collection.dart';

class PasswordGenerator {
  PasswordGenerator() {
    characters.add(CharacterSet.uppercase);
    characters.add(CharacterSet.lowercase);
    characters.add(CharacterSet.numbers);
  }

  int length = 12;
  final CharacterSetCollection characters = CharacterSetCollection();

  String generate() {
    _validate();
    return _createPassword();
  }

  void _validate() {
    if (characters.isEmpty) {
      throw StateError('No character set was specified.');
    }
    if (length < 1 || length > 50) {
      throw RangeError.range(length, 1, 50);
    }
  }

  String _createPassword() {
    String password = '';
    final Random random = Random();

    while (password.length < length) {
      final int characterSetIndex = random.nextInt(characters.length);
      final CharacterSet characterSet = characters.get(characterSetIndex);
      final int characterIndex = random.nextInt(characterSet.length);
      password += characterSet.get(characterIndex);
    }

    return password;
  }
}
