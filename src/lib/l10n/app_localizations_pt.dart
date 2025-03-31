// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get generate_page_title => 'Gerar';

  @override
  String get history_page_title => 'Histórico';

  @override
  String get password_title => 'SENHA GERADA';

  @override
  String get settings_title => 'CONFIGURAÇÕES';

  @override
  String get length_title => 'COMPRIMENTO';

  @override
  String get uppercase_switch_title => 'Letras maiúsculas (ex. ABC)';

  @override
  String get lowercase_switch_title => 'Letras minúsculas (ex. abc)';

  @override
  String get numbers_switch_title => 'Números (ex. 123)';

  @override
  String get symbols_switch_title => 'Símbolos (ex. !@#\$)';

  @override
  String get words_switch_title => 'Palavras (ex. Banana)';

  @override
  String get generate_button_label => 'GERAR SENHA';

  @override
  String get no_password_message => 'Nenhuma senha encontrada';
}
