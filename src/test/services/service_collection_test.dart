import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/domain/password_repository.dart';
import 'package:pwdgen/generate/generate_presenter.dart';
import 'package:pwdgen/generate/generate_view_model.dart';
import 'package:pwdgen/history/history_presenter.dart';
import 'package:pwdgen/history/history_view_model.dart';
import 'package:pwdgen/services/service_collection.dart';
import 'package:pwdgen/services/service_provider.dart';

void main() {
  group('ServiceCollection', () {
    late ServiceCollection services;

    setUp(() {
      services = ServiceCollection();
    });

    test('should add the service', () {
      services.add<String>((_) => 'service');
      final ServiceProvider provider = services.build();
      final String service = provider.get();
      expect(service, 'service');
    });

    test('should replace the service', () {
      services.add<GeneratePresenter>((_) => MockGeneratePresenter());
      final ServiceProvider provider = services.build();
      final GeneratePresenter presenter = provider.get();
      expect(presenter, isA<MockGeneratePresenter>());
    });

    test('should have the default services', () {
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      final ServiceProvider provider = services.build();

      final Map<Type, dynamic> instances = <Type, dynamic>{
        FlutterSecureStorage: provider.get<FlutterSecureStorage>(),
        PasswordRepository: provider.get<PasswordRepository>(),
        GeneratePresenter: provider.get<GeneratePresenter>(),
        GenerateViewModel: provider.get<GenerateViewModel>(),
        HistoryPresenter: provider.get<HistoryPresenter>(),
        HistoryViewModel: provider.get<HistoryViewModel>(),
      };

      instances.forEach((Type runtimeType, dynamic value) {
        expect(value.runtimeType, runtimeType);
      });
    });
  });
}

class MockGeneratePresenter extends Mock implements GeneratePresenter {}
