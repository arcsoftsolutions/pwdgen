import 'password_generator_view_model.dart';

abstract class PasswordGeneratorView {
  void refreshView(PasswordGeneratorViewModel viewModel);
  Future<void> copyToClipboard();
}
