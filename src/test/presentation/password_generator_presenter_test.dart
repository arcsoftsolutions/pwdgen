import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/presentation/password_generator_presenter.dart';
import 'package:pwdgen/presentation/password_generator_view.dart';
import 'package:pwdgen/presentation/password_generator_view_model.dart';

void main() {
  group('PasswordGeneratorPresenter', () {
    late PasswordGeneratorView view;
    late PasswordGeneratorPresenter presenter;

    setUp(() {
      view = MockPasswordGeneratorView();
      presenter = PasswordGeneratorPresenter();
      presenter.setView(view);
      registerFallbackValue(PasswordGeneratorViewModel());
    });

    test('should get view', () {
      expect(presenter.getView(), view);
    });

    test('should set length', () {
      presenter.setLength(32);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.length,
        'length',
        32,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should enable uppercase', () {
      presenter.enableUppercase(true);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.uppercase,
        'uppercase',
        true,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should disable uppercase', () {
      presenter.enableUppercase(false);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.uppercase,
        'uppercase',
        false,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should enable lowercase', () {
      presenter.enableLowercase(true);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.lowercase,
        'lowercase',
        true,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should disable lowercase', () {
      presenter.enableLowercase(false);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.lowercase,
        'lowercase',
        false,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should enable numbers', () {
      presenter.enableNumbers(true);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.numbers,
        'numbers',
        true,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should disable numbers', () {
      presenter.enableNumbers(false);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.numbers,
        'numbers',
        false,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should enable symbols', () {
      presenter.enableSymbols(true);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.symbols,
        'symbols',
        true,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should disable symbols', () {
      presenter.enableSymbols(false);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.symbols,
        'symbols',
        false,
      );

      verify(() => view.refreshView(any(that: matcher))).called(1);
    });

    test('should copy to clipboard when copying a password', () {
      when(() => view.copyToClipboard())
          .thenAnswer((_) => Future<void>.value());
      presenter.copyPassword();
      verify(() => view.copyToClipboard()).called(1);
    });

    test('should generate password', () {
      presenter.enableUppercase(true);
      presenter.enableLowercase(true);
      presenter.enableNumbers(true);
      presenter.enableSymbols(true);
      reset(view);

      final TypeMatcher<PasswordGeneratorViewModel> matcher =
          isA<PasswordGeneratorViewModel>().having(
        (PasswordGeneratorViewModel viewModel) => viewModel.password,
        'password',
        isNotEmpty,
      );

      presenter.generatePassword();
      verify(() => view.refreshView(any(that: matcher))).called(1);
    });
  });
}

class MockPasswordGeneratorView extends Mock implements PasswordGeneratorView {}
