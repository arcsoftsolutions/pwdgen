import 'password_component.dart';

class CharacterSetComponent implements PasswordComponent {
  CharacterSetComponent(String characters) {
    _characters = characters.split('');
  }

  late final List<String> _characters;

  @override
  int get length => _characters.length;

  @override
  String get(int index) {
    return _characters.elementAt(index);
  }
}
