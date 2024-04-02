import 'service_collection.dart';
import 'service_provider.dart';

class ServiceLocator {
  static ServiceProvider _provider = ServiceCollection().build();

  static TService get<TService>() {
    return _provider.get();
  }

  static void setServices(ServiceCollection services) {
    _provider = services.build();
  }
}
