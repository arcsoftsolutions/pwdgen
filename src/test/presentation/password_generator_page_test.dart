import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/presentation/password_generator_module.dart';
import 'package:pwdgen/presentation/password_generator_page.dart';
import 'package:pwdgen/presentation/password_generator_presenter.dart';
import 'package:pwdgen/presentation/password_generator_view_model.dart';

void main() {
  LiveTestWidgetsFlutterBinding();

  group('PasswordGeneratorPage', () {
    late PasswordGeneratorPresenter presenter;

    const Key LENGTH_SLIDER = Key('length-slider');
    const Key UPPERCASE_CHECKBOX = Key('uppercase-checkbox');
    const Key LOWERCASE_CHECKBOX = Key('lowercase-checkbox');
    const Key NUMBERS_CHECKBOX = Key('numbers-checkbox');
    const Key SYMBOLS_CHECKBOX = Key('symbols-checkbox');
    const Key GENERATE_BUTTON = Key('generate-button');
    const Key COPY_BUTTON = Key('copy-button');

    setUp(() {
      presenter = MockPasswordGeneratorPresenter();
      PasswordGeneratorModule.replace<PasswordGeneratorPresenter>(presenter);
    });

    testWidgets('should invoke setLength when moving length slider',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      await tester.drag(find.byKey(LENGTH_SLIDER), const Offset(1, 0));
      verify(() => presenter.setLength(any())).called(1);
    });

    testWidgets(
        'should invoke enableUppercase when clicking on uppercase checkbox',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      await tester.tap(find.byKey(UPPERCASE_CHECKBOX));
      verify(() => presenter.enableUppercase(any())).called(1);
    });

    testWidgets(
        'should invoke enableLowercase when clicking on lowercase checkbox',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      await tester.tap(find.byKey(LOWERCASE_CHECKBOX));
      verify(() => presenter.enableLowercase(any())).called(1);
    });

    testWidgets('should invoke enableNumbers when clicking on numbers checkbox',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      await tester.tap(find.byKey(NUMBERS_CHECKBOX));
      verify(() => presenter.enableNumbers(any())).called(1);
    });

    testWidgets('should invoke enableSymbols when clicking on symbols checkbox',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      await tester.tap(find.byKey(SYMBOLS_CHECKBOX));
      verify(() => presenter.enableSymbols(any())).called(1);
    });

    testWidgets('should generate password when clicking on generate button',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      await tester.tap(find.byKey(GENERATE_BUTTON));
      verify(() => presenter.generatePassword()).called(1);
    });

    testWidgets('should not generate password when there is no character set',
        (WidgetTester tester) async {
      final GlobalKey<PasswordGeneratorPageState> state = GlobalKey();
      await _pumpPasswordGeneratorPage(tester, state: state);

      final PasswordGeneratorViewModel viewModel = PasswordGeneratorViewModel();
      viewModel.uppercase = false;
      viewModel.lowercase = false;
      viewModel.numbers = false;
      viewModel.symbols = false;
      state.currentState?.refreshView(viewModel);
      await tester.pump();

      final Finder finder = find.byKey(GENERATE_BUTTON);
      final FilledButton button = tester.widget<FilledButton>(finder);
      expect(button.enabled, isFalse);
      await tester.tap(finder);
      verifyNever(() => presenter.generatePassword());
    });

    testWidgets('should copy password when clicking on copy button',
        (WidgetTester tester) async {
      final GlobalKey<PasswordGeneratorPageState> state = GlobalKey();
      await _pumpPasswordGeneratorPage(tester, state: state);

      when(() => presenter.copyPassword()).thenAnswer((_) async {
        await tester.runAsync(() async {
          await state.currentState?.copyToClipboard();
        });
      });

      final PasswordGeneratorViewModel viewModel = PasswordGeneratorViewModel();
      viewModel.password = 'password';
      state.currentState?.refreshView(viewModel);
      await tester.pump();

      await tester.tap(find.byKey(COPY_BUTTON));
      await tester.pumpAndSettle();
      verify(() => presenter.copyPassword()).called(1);
    });

    testWidgets('should not copy the password before generating it',
        (WidgetTester tester) async {
      await _pumpPasswordGeneratorPage(tester);
      final Finder finder = find.byKey(COPY_BUTTON);
      final FilledButton button = tester.widget<FilledButton>(finder);
      expect(button.enabled, isFalse);
      await tester.tap(finder);
      verifyNever(() => presenter.copyPassword());
    });
  });
}

class MockPasswordGeneratorPresenter extends Mock
    implements PasswordGeneratorPresenter {}

Future<void> _pumpPasswordGeneratorPage(
  WidgetTester tester, {
  GlobalKey<PasswordGeneratorPageState>? state,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PasswordGeneratorPage(key: state),
    ),
  );
}
