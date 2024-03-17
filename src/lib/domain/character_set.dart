class CharacterSet {
  CharacterSet._(String characters) {
    _characters = characters.split('');
    _pattern = RegExp('^[$characters]+\$');
  }

  static final CharacterSet uppercase = CharacterSet._(
    r'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  );

  static final CharacterSet lowercase = CharacterSet._(
    r'abcdefghijklmnopqrstuvwxyz',
  );

  static final CharacterSet numbers = CharacterSet._(
    r'0123456789',
  );

  static final CharacterSet symbols = CharacterSet._(
    r'*!@#$%&',
  );

  late final RegExp _pattern;
  late final List<String> _characters;

  int get length => _characters.length;

  bool match(String value) {
    return _pattern.hasMatch(value);
  }

  String get(int index) {
    return _characters.elementAt(index);
  }
}
