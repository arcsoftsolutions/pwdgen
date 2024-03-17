import 'password_generator_presenter.dart';

class PasswordGeneratorModule {
  static final Map<dynamic, dynamic> _components = <dynamic, dynamic>{
    PasswordGeneratorPresenter: PasswordGeneratorPresenter(),
  };

  static T get<T>() {
    if (_components.containsKey(T)) {
      return _components[T] as T;
    }
    throw _createComponentNotRegisteredError<T>();
  }

  static void replace<T>(T instance) {
    _components.update(
      T,
      (_) => instance,
      ifAbsent: () {
        throw _createComponentNotRegisteredError<T>();
      },
    );
  }

  static UnsupportedError _createComponentNotRegisteredError<T>() {
    return UnsupportedError("Component '$T' is not registered.");
  }
}
