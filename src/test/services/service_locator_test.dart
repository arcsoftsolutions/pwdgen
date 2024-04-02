import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/generate/generate_view_model.dart';
import 'package:pwdgen/services/service_collection.dart';
import 'package:pwdgen/services/service_locator.dart';

void main() {
  group('ServiceLocator', () {
    test('should get the default service', () {
      final GenerateViewModel viewModel = ServiceLocator.get();
      expect(viewModel, isNotNull);
    });

    test('should set the services', () {
      final ServiceCollection services = ServiceCollection();
      services.add<String>((_) => 'service');
      ServiceLocator.setServices(services);

      final String service = ServiceLocator.get();
      expect(service, 'service');
    });
  });
}
