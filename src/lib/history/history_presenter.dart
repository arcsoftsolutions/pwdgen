import '../domain/password_model.dart';
import '../domain/password_repository.dart';
import 'history_view.dart';
import 'history_view_model.dart';
import 'password_view_model.dart';

class HistoryPresenter {
  HistoryPresenter(this._repository);

  final PasswordRepository _repository;
  late HistoryView _view;
  late HistoryViewModel _viewModel;

  HistoryView getView() {
    return _view;
  }

  void setView(HistoryView view) {
    _view = view;
  }

  HistoryViewModel getViewModel() {
    return _viewModel;
  }

  void setViewModel(HistoryViewModel viewModel) {
    _viewModel = viewModel;
  }

  Future<void> load() async {
    final List<PasswordModel> passwords = await _repository.findAll();
    _viewModel.passwords = passwords.map(PasswordViewModel.new).toList();
    _view.refreshView();
  }

  Future<void> copyPassword(PasswordViewModel password) async {
    if (!password.removed) {
      await _view.copyToClipboard(password.password);
    }
  }

  Future<bool> removePassword(PasswordViewModel password) async {
    if (!password.removed) {
      password.removed = true;
      await _repository.remove(password.model);
      await load();
      return true;
    }
    return false;
  }
}
