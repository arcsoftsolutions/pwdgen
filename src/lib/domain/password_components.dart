import 'character_set_component.dart';
import 'password_component.dart';
import 'word_set_component.dart';

abstract class PasswordComponents {
  PasswordComponents._();

  static final PasswordComponent uppercase =
      CharacterSetComponent(r'ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  static final PasswordComponent lowercase =
      CharacterSetComponent(r'abcdefghijklmnopqrstuvwxyz');

  static final PasswordComponent numbers = CharacterSetComponent(r'0123456789');
  static final PasswordComponent symbols = CharacterSetComponent(r'*!@#$%&');
  static final PasswordComponent words = WordSetComponent();
}
