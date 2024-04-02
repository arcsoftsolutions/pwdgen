import '../domain/password_components.dart';
import '../domain/password_generator.dart';
import '../domain/password_model.dart';
import '../domain/password_repository.dart';
import 'generate_view.dart';
import 'generate_view_model.dart';

class GeneratePresenter {
  GeneratePresenter(this._repository);

  final PasswordRepository _repository;
  late GenerateView _view;
  late GenerateViewModel _viewModel;
  late PasswordModel _password;

  GenerateView getView() {
    return _view;
  }

  void setView(GenerateView view) {
    _view = view;
  }

  GenerateViewModel getViewModel() {
    return _viewModel;
  }

  void setViewModel(GenerateViewModel viewModel) {
    _viewModel = viewModel;
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

  void enableWords(bool enabled) {
    _viewModel.words = enabled;
    _refreshView();
  }

  void generatePassword() {
    final PasswordGenerator generator = PasswordGenerator();
    generator.length = _viewModel.length;
    generator.components.clear();

    if (_viewModel.uppercase) {
      generator.components.add(PasswordComponents.uppercase);
    }
    if (_viewModel.lowercase) {
      generator.components.add(PasswordComponents.lowercase);
    }
    if (_viewModel.numbers) {
      generator.components.add(PasswordComponents.numbers);
    }
    if (_viewModel.symbols) {
      generator.components.add(PasswordComponents.symbols);
    }
    if (_viewModel.words) {
      generator.components.add(PasswordComponents.words);
    }

    final String password = generator.generate();
    _password = PasswordModel(password);
    _viewModel.password = password;
    _refreshView();
  }

  Future<void> copyPassword() async {
    await _repository.add(_password);
    await _view.copyToClipboard();
  }

  void _refreshView() {
    _view.refreshView();
  }
}
