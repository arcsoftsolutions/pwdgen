import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/password_repository.dart';
import '../generate/generate_presenter.dart';
import '../generate/generate_view_model.dart';
import '../history/history_presenter.dart';
import '../history/history_view_model.dart';
import 'service_provider.dart';

class ServiceCollection {
  ServiceCollection() {
    add<FlutterSecureStorage>((_) => const FlutterSecureStorage());
    add<PasswordRepository>(
        (ServiceProvider provider) => PasswordRepository(provider.get()));
    add<GeneratePresenter>(
        (ServiceProvider provider) => GeneratePresenter(provider.get()));
    add<GenerateViewModel>((_) => GenerateViewModel());
    add<HistoryPresenter>(
        (ServiceProvider provider) => HistoryPresenter(provider.get()));
    add<HistoryViewModel>((_) => HistoryViewModel());
  }

  final Map<Type, ServiceFactory<dynamic>> _factories =
      <Type, ServiceFactory<dynamic>>{};

  ServiceCollection add<TService>(ServiceFactory<TService> factory) {
    _factories.update(TService, (_) => factory, ifAbsent: () => factory);
    return this;
  }

  ServiceProvider build() {
    return ServiceProvider(
      Map<Type, ServiceFactory<dynamic>>.from(_factories),
    );
  }
}
