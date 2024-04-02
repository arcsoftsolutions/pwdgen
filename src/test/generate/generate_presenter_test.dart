import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/domain/password_model.dart';
import 'package:pwdgen/domain/password_repository.dart';
import 'package:pwdgen/generate/generate_presenter.dart';
import 'package:pwdgen/generate/generate_view.dart';
import 'package:pwdgen/generate/generate_view_model.dart';

void main() {
  group('GeneratePresenter', () {
    late GenerateView view;
    late GenerateViewModel viewModel;
    late GeneratePresenter presenter;
    late PasswordRepository repository;

    setUp(() {
      view = MockGenerateView();
      repository = MockPasswordRepository();
      viewModel = GenerateViewModel();
      presenter = GeneratePresenter(repository);
      presenter.setView(view);
      presenter.setViewModel(viewModel);
      registerFallbackValue(PasswordModel('password'));
    });

    test('should get the view', () {
      expect(presenter.getView(), view);
    });

    test('should get the view model', () {
      expect(presenter.getViewModel(), viewModel);
    });

    test('should set length', () {
      presenter.setLength(32);
      expect(viewModel.length, 32);
      verify(() => view.refreshView()).called(1);
    });

    test('should enable uppercase', () {
      presenter.enableUppercase(true);
      expect(viewModel.uppercase, true);
      verify(() => view.refreshView()).called(1);
    });

    test('should disable uppercase', () {
      presenter.enableUppercase(false);
      expect(viewModel.uppercase, false);
      verify(() => view.refreshView()).called(1);
    });

    test('should enable lowercase', () {
      presenter.enableLowercase(true);
      expect(viewModel.lowercase, true);
      verify(() => view.refreshView()).called(1);
    });

    test('should disable lowercase', () {
      presenter.enableLowercase(false);
      expect(viewModel.lowercase, false);
      verify(() => view.refreshView()).called(1);
    });

    test('should enable numbers', () {
      presenter.enableNumbers(true);
      expect(viewModel.numbers, true);
      verify(() => view.refreshView()).called(1);
    });

    test('should disable numbers', () {
      presenter.enableNumbers(false);
      expect(viewModel.numbers, false);
      verify(() => view.refreshView()).called(1);
    });

    test('should enable symbols', () {
      presenter.enableSymbols(true);
      expect(viewModel.symbols, true);
      verify(() => view.refreshView()).called(1);
    });

    test('should disable symbols', () {
      presenter.enableSymbols(false);
      expect(viewModel.symbols, false);
      verify(() => view.refreshView()).called(1);
    });

    test('should enable words', () {
      presenter.enableWords(true);
      expect(viewModel.words, true);
      verify(() => view.refreshView()).called(1);
    });

    test('should disable words', () {
      presenter.enableWords(false);
      expect(viewModel.words, false);
      verify(() => view.refreshView()).called(1);
    });

    test('should copy to clipboard when copying a password', () async {
      final Future<void> future = Future<void>.value();
      when(() => view.copyToClipboard()).thenAnswer((_) => future);
      when(() => repository.add(any())).thenAnswer((_) => future);

      presenter.generatePassword();
      await presenter.copyPassword();

      verify(() => view.copyToClipboard()).called(1);
      verify(() => repository.add(any())).called(1);
    });

    test('should generate password', () {
      presenter.enableUppercase(true);
      presenter.enableLowercase(true);
      presenter.enableNumbers(true);
      presenter.enableSymbols(true);
      presenter.enableWords(true);
      reset(view);

      presenter.generatePassword();
      expect(viewModel.password, isNotEmpty);
      verify(() => view.refreshView()).called(1);
    });
  });
}

class MockGenerateView extends Mock implements GenerateView {}

class MockPasswordRepository extends Mock implements PasswordRepository {}
