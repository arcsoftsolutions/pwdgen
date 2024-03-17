import 'character_set.dart';

class CharacterSetCollection {
  final Set<CharacterSet> _characters = <CharacterSet>{};

  int get length {
    return _characters.length;
  }

  bool get isEmpty {
    return length == 0;
  }

  bool get isNotEmpty {
    return length != 0;
  }

  void clear() {
    _characters.clear();
  }

  void add(CharacterSet characterSet) {
    _characters.add(characterSet);
  }

  void remove(CharacterSet characterSet) {
    _characters.remove(characterSet);
  }

  bool contains(CharacterSet characterSet) {
    return _characters.contains(characterSet);
  }

  CharacterSet get(int index) {
    return _characters.elementAt(index);
  }
}
