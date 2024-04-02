import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/domain/password_model.dart';
import 'package:pwdgen/domain/password_repository.dart';
import 'package:pwdgen/history/history_presenter.dart';
import 'package:pwdgen/history/history_view.dart';
import 'package:pwdgen/history/history_view_model.dart';
import 'package:pwdgen/history/password_view_model.dart';

void main() {
  group('HistoryPresenter', () {
    late HistoryView view;
    late HistoryViewModel viewModel;
    late HistoryPresenter presenter;
    late PasswordRepository repository;

    setUp(() {
      view = MockHistoryView();
      repository = MockPasswordRepository();
      viewModel = HistoryViewModel();
      presenter = HistoryPresenter(repository);
      presenter.setView(view);
      presenter.setViewModel(viewModel);
    });

    test('should get the view', () {
      expect(presenter.getView(), view);
    });

    test('should get the view model', () {
      expect(presenter.getViewModel(), viewModel);
    });

    test('should load passwords', () async {
      when(() => repository.findAll()).thenAnswer(
        (_) => Future<List<PasswordModel>>.value(<PasswordModel>[]),
      );

      await presenter.load();
      verify(() => repository.findAll()).called(1);
      verify(() => view.refreshView()).called(1);
    });

    test('should copy to clipboard when copying a password', () async {
      when(() => view.copyToClipboard(any()))
          .thenAnswer((_) => Future<void>.value());

      final PasswordModel model = PasswordModel('password');
      final PasswordViewModel viewModel = PasswordViewModel(model);
      await presenter.copyPassword(viewModel);

      verify(() => view.copyToClipboard('password')).called(1);
    });

    test('should remove the password', () async {
      final PasswordModel model = PasswordModel('password');
      final PasswordViewModel viewModel = PasswordViewModel(model);

      when(() => repository.findAll()).thenAnswer(
        (_) => Future<List<PasswordModel>>.value(<PasswordModel>[]),
      );

      when(() => repository.remove(model)).thenAnswer(
        (_) => Future<void>.value(),
      );

      await presenter.removePassword(viewModel);
      expect(viewModel.removed, isTrue);

      verify(() => repository.remove(model)).called(1);
      verify(() => view.refreshView()).called(1);
    });
  });
}

class MockHistoryView extends Mock implements HistoryView {}

class MockPasswordRepository extends Mock implements PasswordRepository {}
