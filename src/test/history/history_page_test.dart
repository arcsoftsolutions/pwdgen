import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/domain/password_model.dart';
import 'package:pwdgen/extensions/string_extensions.dart';
import 'package:pwdgen/history/history_page.dart';
import 'package:pwdgen/history/history_presenter.dart';
import 'package:pwdgen/history/history_view_model.dart';
import 'package:pwdgen/history/password_view_model.dart';
import 'package:pwdgen/services/service_collection.dart';
import 'package:pwdgen/services/service_locator.dart';

void main() {
  group('HistoryPage', () {
    const Key NO_PASSWORD_MESSAGE = Key('test_no_password_message');
    const Key PASSWORD_LABEL = Key('test_password_label');
    const Key PASSWORD_REMOVE_BUTTON = Key('test_password_remove_button');
    const Key PASSWORD_COPY_BUTTON = Key('test_password_copy_button');

    final PasswordViewModel mockPassword1 =
        PasswordViewModel(PasswordModel('password1'));

    final PasswordViewModel mockPassword2 =
        PasswordViewModel(PasswordModel('password2'));

    late HistoryPresenter presenter;
    late HistoryViewModel viewModel;

    setUp(() {
      presenter = MockHistoryPresenter();
      viewModel = HistoryViewModel();

      when(() => presenter.load()).thenAnswer((_) => Future<void>.value());

      final ServiceCollection services = ServiceCollection()
          .add<HistoryViewModel>((_) => viewModel)
          .add<HistoryPresenter>((_) => presenter);

      ServiceLocator.setServices(services);
    });

    testWidgets('should show the message of no password found',
        (WidgetTester tester) async {
      await _pumpHistoryPage(tester);
      final Text text = tester.widget<Text>(find.byKey(NO_PASSWORD_MESSAGE));
      expect(text.data, 'No password found');
    });

    testWidgets('should show the password', (WidgetTester tester) async {
      viewModel.passwords = <PasswordViewModel>[mockPassword1];
      await _pumpHistoryPage(tester);
      await tester.pump(Durations.medium2);
      final Text text = tester.widget<Text>(find.byKey(PASSWORD_LABEL));
      expect(text.data, mockPassword1.password.breakWord());
    });

    testWidgets('should insert new passwords', (WidgetTester tester) async {
      final GlobalKey<HistoryPageState> state = GlobalKey();
      viewModel.passwords = <PasswordViewModel>[mockPassword1];

      await _pumpHistoryPage(tester, state: state);
      await tester.pump(Durations.medium2);

      viewModel.passwords.add(mockPassword2);
      state.currentState?.refreshView();
      await tester.pump(Durations.medium2);

      final Iterable<Text> texts =
          tester.widgetList<Text>(find.byKey(PASSWORD_LABEL));

      expect(texts, hasLength(2));
    });

    testWidgets('should remove the password when tapping on copy button',
        (WidgetTester tester) async {
      final GlobalKey<HistoryPageState> state = GlobalKey();
      viewModel.passwords = <PasswordViewModel>[mockPassword1];

      when(() => presenter.removePassword(mockPassword1)).thenAnswer((_) {
        viewModel.passwords.remove(mockPassword1);
        state.currentState?.refreshView();
        return Future<bool>.value(true);
      });

      await _pumpHistoryPage(tester, state: state);
      await tester.pump(Durations.medium2);

      final Finder finder = find.byKey(PASSWORD_REMOVE_BUTTON);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      verify(() => presenter.removePassword(mockPassword1)).called(1);
    });

    testWidgets('should copy the password when tapping on copy button',
        (WidgetTester tester) async {
      final GlobalKey<HistoryPageState> state = GlobalKey();
      viewModel.passwords = <PasswordViewModel>[mockPassword1];

      when(() => presenter.copyPassword(mockPassword1)).thenAnswer((_) async {
        await tester.runAsync(() async {
          await state.currentState?.copyToClipboard(mockPassword1.password);
        });
      });

      await _pumpHistoryPage(tester, state: state);
      await tester.pump(Durations.medium2);

      final Finder finder = find.byKey(PASSWORD_COPY_BUTTON);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      verify(() => presenter.copyPassword(mockPassword1)).called(1);
    });

    testWidgets('should get the page title', (WidgetTester tester) async {
      final GlobalKey<HistoryPageState> state = GlobalKey();
      await _pumpHistoryPage(tester, state: state);
      final HistoryPage page = state.currentState!.widget;
      final BuildContext context = state.currentState!.context;
      expect(page.getTitle(context), 'History');
    });

    testWidgets('should get the page icon', (WidgetTester tester) async {
      final GlobalKey<HistoryPageState> state = GlobalKey();
      await _pumpHistoryPage(tester, state: state);
      final HistoryPage page = state.currentState!.widget;
      expect(page.getIcon().icon, Icons.schedule_rounded);
    });
  });
}

class MockHistoryPresenter extends Mock implements HistoryPresenter {}

Future<void> _pumpHistoryPage(
  WidgetTester tester, {
  GlobalKey<HistoryPageState>? state,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HistoryPage(key: state),
    ),
  );
}
