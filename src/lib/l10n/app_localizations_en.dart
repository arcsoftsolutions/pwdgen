// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get generate_page_title => 'Generate';

  @override
  String get history_page_title => 'History';

  @override
  String get password_title => 'PASSWORD GENERATED';

  @override
  String get settings_title => 'SETTINGS';

  @override
  String get length_title => 'LENGTH';

  @override
  String get uppercase_switch_title => 'Uppercase (eg. ABC)';

  @override
  String get lowercase_switch_title => 'Lowercase (eg. abc)';

  @override
  String get numbers_switch_title => 'Numbers (eg. 123)';

  @override
  String get symbols_switch_title => 'Symbols (eg. !@#\$)';

  @override
  String get words_switch_title => 'Words (eg. Banana)';

  @override
  String get generate_button_label => 'GENERATE PASSWORD';

  @override
  String get no_password_message => 'No password found';
}
