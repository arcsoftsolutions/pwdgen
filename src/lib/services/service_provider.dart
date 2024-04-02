typedef ServiceFactory<TService> = TService Function(ServiceProvider provider);

class ServiceProvider {
  ServiceProvider(this._factories);

  final Map<Type, ServiceFactory<dynamic>> _factories;
  final Map<Type, dynamic> _instances = <Type, dynamic>{};

  static UnsupportedError _createServiceNotRegisteredError<TService>() {
    return UnsupportedError("Service '$TService' is not registered.");
  }

  TService get<TService>() {
    return _instances.putIfAbsent(
      TService,
      () => _createInstance<TService>(),
    ) as TService;
  }

  ServiceFactory<TService> _getFactory<TService>() {
    if (_factories.containsKey(TService)) {
      return _factories[TService]! as ServiceFactory<TService>;
    }
    throw _createServiceNotRegisteredError<TService>();
  }

  TService _createInstance<TService>() {
    final ServiceFactory<TService> factory = _getFactory<TService>();
    return factory(this);
  }
}
