import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/presentation/password_generator_module.dart';
import 'package:pwdgen/presentation/password_generator_presenter.dart';

void main() {
  group('PasswordGeneratorModule', () {
    test('should get PasswordGeneratorPresenter', () {
      final PasswordGeneratorPresenter presenter =
          PasswordGeneratorModule.get();
      expect(presenter, isNotNull);
    });

    test('should throw UnsupportedError when the component is not registered',
        () {
      expect(() => PasswordGeneratorModule.get<int>(), throwsUnsupportedError);
    });

    test(
        'should replace the PasswordGeneratorPresenter by MockPasswordGeneratorPresenter',
        () {
      final PasswordGeneratorPresenter presenter =
          MockPasswordGeneratorPresenter();
      PasswordGeneratorModule.replace<PasswordGeneratorPresenter>(presenter);
      expect(
        PasswordGeneratorModule.get<PasswordGeneratorPresenter>(),
        presenter,
      );
    });

    test(
        'should throw UnsupportedError when attempting to replace a component that is not registered',
        () {
      expect(
        () => PasswordGeneratorModule.replace<int>(0),
        throwsUnsupportedError,
      );
    });
  });
}

class MockPasswordGeneratorPresenter extends Mock
    implements PasswordGeneratorPresenter {}
