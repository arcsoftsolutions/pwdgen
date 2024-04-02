import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwdgen/extensions/string_extensions.dart';
import 'package:pwdgen/generate/generate_page.dart';
import 'package:pwdgen/generate/generate_presenter.dart';
import 'package:pwdgen/generate/generate_view_model.dart';
import 'package:pwdgen/services/service_collection.dart';
import 'package:pwdgen/services/service_locator.dart';

void main() {
  group('GeneratePage', () {
    const Key PASSWORD_LABEL = Key('test_password_label');
    const Key LENGTH_SLIDER = Key('test_length_slider');
    const Key UPPERCASE_SWITCH = Key('test_uppercase_switch');
    const Key LOWERCASE_SWITCH = Key('test_lowercase_switch');
    const Key NUMBERS_SWITCH = Key('test_numbers_switch');
    const Key SYMBOLS_SWITCH = Key('test_symbols_switch');
    const Key WORDS_SWITCH = Key('test_words_switch');
    const Key GENERATE_BUTTON = Key('test_generate_button');
    const Key COPY_BUTTON = Key('test_copy_button');

    late GeneratePresenter presenter;
    late GenerateViewModel viewModel;

    setUp(() {
      presenter = MockGeneratePresenter();
      viewModel = GenerateViewModel();

      final ServiceCollection services = ServiceCollection()
          .add<GenerateViewModel>((_) => viewModel)
          .add<GeneratePresenter>((_) => presenter);

      ServiceLocator.setServices(services);
    });

    testWidgets('should invoke setLength when moving length slider',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.drag(find.byKey(LENGTH_SLIDER), const Offset(1, 0));
      verify(() => presenter.setLength(any())).called(greaterThan(0));
    });

    testWidgets(
        'should invoke enableUppercase when tapping on uppercase switch',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.tap(find.byKey(UPPERCASE_SWITCH));
      verify(() => presenter.enableUppercase(any())).called(1);
    });

    testWidgets(
        'should invoke enableLowercase when tapping on lowercase switch',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.tap(find.byKey(LOWERCASE_SWITCH));
      verify(() => presenter.enableLowercase(any())).called(1);
    });

    testWidgets('should invoke enableNumbers when tapping on numbers switch',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.tap(find.byKey(NUMBERS_SWITCH));
      verify(() => presenter.enableNumbers(any())).called(1);
    });

    testWidgets('should invoke enableSymbols when tapping on symbols switch',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.tap(find.byKey(SYMBOLS_SWITCH));
      verify(() => presenter.enableSymbols(any())).called(1);
    });

    testWidgets('should invoke enableWords when tapping on words switch',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.tap(find.byKey(WORDS_SWITCH));
      verify(() => presenter.enableWords(any())).called(1);
    });

    testWidgets('should generate password when tapping on generate button',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      await tester.tap(find.byKey(GENERATE_BUTTON));
      verify(() => presenter.generatePassword()).called(1);
    });

    testWidgets(
        'should not generate password when there is no password component',
        (WidgetTester tester) async {
      final GlobalKey<GeneratePageState> state = GlobalKey();
      viewModel.uppercase = false;
      viewModel.lowercase = false;
      viewModel.numbers = false;
      viewModel.symbols = false;
      viewModel.words = false;

      await _pumpGeneratePage(tester, state: state);
      final Finder finder = find.byKey(GENERATE_BUTTON);
      final FilledButton button = tester.widget<FilledButton>(finder);
      expect(button.enabled, isFalse);
      await tester.tap(finder);
      verifyNever(() => presenter.generatePassword());
    });

    testWidgets('should copy password when tapping on copy button',
        (WidgetTester tester) async {
      final GlobalKey<GeneratePageState> state = GlobalKey();
      viewModel.password = 'password';

      when(() => presenter.copyPassword()).thenAnswer((_) async {
        await tester.runAsync(() async {
          await state.currentState?.copyToClipboard();
        });
      });

      await _pumpGeneratePage(tester, state: state);
      await tester.tap(find.byKey(COPY_BUTTON));
      await tester.pumpAndSettle();
      verify(() => presenter.copyPassword()).called(1);
    });

    testWidgets('should not copy the password before generating it',
        (WidgetTester tester) async {
      await _pumpGeneratePage(tester);
      final Finder finder = find.byKey(COPY_BUTTON);
      final IconButton button = tester.widget<IconButton>(finder);
      expect(button.onPressed, isNull);
      await tester.tap(finder);
      verifyNever(() => presenter.copyPassword());
    });

    testWidgets('should refresh the view', (WidgetTester tester) async {
      final GlobalKey<GeneratePageState> state = GlobalKey();
      await _pumpGeneratePage(tester, state: state);

      viewModel.password = 'password';
      state.currentState?.refreshView();
      await tester.pump();

      final Text text = tester.widget<Text>(find.byKey(PASSWORD_LABEL));
      expect(text.data, viewModel.password.breakWord());
    });

    testWidgets('should get the page title', (WidgetTester tester) async {
      final GlobalKey<GeneratePageState> state = GlobalKey();
      await _pumpGeneratePage(tester, state: state);
      final GeneratePage page = state.currentState!.widget;
      final BuildContext context = state.currentState!.context;
      expect(page.getTitle(context), 'Generate');
    });

    testWidgets('should get the page icon', (WidgetTester tester) async {
      final GlobalKey<GeneratePageState> state = GlobalKey();
      await _pumpGeneratePage(tester, state: state);
      final GeneratePage page = state.currentState!.widget;
      expect(page.getIcon().icon, Icons.lock_outline_rounded);
    });
  });
}

class MockGeneratePresenter extends Mock implements GeneratePresenter {}

Future<void> _pumpGeneratePage(
  WidgetTester tester, {
  GlobalKey<GeneratePageState>? state,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GeneratePage(key: state),
    ),
  );
}
