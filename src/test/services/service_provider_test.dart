import 'package:flutter_test/flutter_test.dart';
import 'package:pwdgen/services/service_collection.dart';
import 'package:pwdgen/services/service_provider.dart';

void main() {
  group('ServiceProvider', () {
    late ServiceProvider provider;

    setUp(() {
      final ServiceCollection services = ServiceCollection();
      services.add<String>((_) => 'service');
      provider = services.build();
    });

    test('should get the service', () async {
      final String service = provider.get();
      expect(service, 'service');
    });

    test('should throw UnsupportedError when the service is not registered',
        () {
      expect(() => provider.get<int>(), throwsUnsupportedError);
    });
  });
}
