import '../domain/character_set.dart';
import '../domain/password_generator.dart';
import 'password_generator_view.dart';
import 'password_generator_view_model.dart';

class PasswordGeneratorPresenter {
  late PasswordGeneratorView _view;
  final PasswordGeneratorViewModel _viewModel = PasswordGeneratorViewModel();

  PasswordGeneratorView getView() {
    return _view;
  }

  void setView(PasswordGeneratorView view) {
    _view = view;
  }

  void setLength(int length) {
    _viewModel.length = length;
    _refreshView();
  }

  void enableUppercase(bool enabled) {
    _viewModel.uppercase = enabled;
    _refreshView();
  }

  void enableLowercase(bool enabled) {
    _viewModel.lowercase = enabled;
    _refreshView();
  }

  void enableNumbers(bool enabled) {
    _viewModel.numbers = enabled;
    _refreshView();
  }

  void enableSymbols(bool enabled) {
    _viewModel.symbols = enabled;
    _refreshView();
  }

  void generatePassword() {
    final PasswordGenerator generator = PasswordGenerator();
    generator.length = _viewModel.length;
    generator.characters.clear();

    if (_viewModel.uppercase) {
      generator.characters.add(CharacterSet.uppercase);
    }
    if (_viewModel.lowercase) {
      generator.characters.add(CharacterSet.lowercase);
    }
    if (_viewModel.numbers) {
      generator.characters.add(CharacterSet.numbers);
    }
    if (_viewModel.symbols) {
      generator.characters.add(CharacterSet.symbols);
    }

    _viewModel.password = generator.generate();
    _refreshView();
  }

  Future<void> copyPassword() async {
    await _view.copyToClipboard();
  }

  void _refreshView() {
    _view.refreshView(_viewModel);
  }
}
