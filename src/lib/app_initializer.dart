import 'domain/password_model.dart';
import 'domain/password_repository.dart';
import 'history/history_view_model.dart';
import 'history/password_view_model.dart';
import 'services/service_locator.dart';

class AppInitializer {
  Future<void> initialize() async {
    await _preloadHistoryPasswords();
  }

  Future<void> _preloadHistoryPasswords() async {
    final PasswordRepository passwordRepository = ServiceLocator.get();
    final HistoryViewModel historyViewModel = ServiceLocator.get();
    final List<PasswordModel> passwords = await passwordRepository.findAll();
    historyViewModel.passwords = passwords.map(PasswordViewModel.new).toList();
  }
}
