import 'password_component.dart';

class PasswordComponentCollection {
  final Set<PasswordComponent> _components = <PasswordComponent>{};

  int get length {
    return _components.length;
  }

  bool get isEmpty {
    return length == 0;
  }

  bool get isNotEmpty {
    return length != 0;
  }

  void clear() {
    _components.clear();
  }

  void add(PasswordComponent component) {
    _components.add(component);
  }

  void remove(PasswordComponent component) {
    _components.remove(component);
  }

  bool contains(PasswordComponent component) {
    return _components.contains(component);
  }

  PasswordComponent get(int index) {
    return _components.elementAt(index);
  }
}
