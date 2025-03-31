import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/password_constants.dart';
import '../extensions/string_extensions.dart';
import '../l10n/app_localizations.dart';
import '../services/service_locator.dart';
import '../shared/bottom_navigation_page.dart';
import '../shared/control_container.dart';
import 'generate_presenter.dart';
import 'generate_view.dart';
import 'generate_view_model.dart';

class GeneratePage extends StatefulWidget implements BottomNavigationPage {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() {
    return GeneratePageState();
  }

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context)!.generate_page_title;
  }

  @override
  Icon getIcon() {
    return const Icon(Icons.lock_outline_rounded);
  }
}

class GeneratePageState extends State<GeneratePage> implements GenerateView {
  final GeneratePresenter _presenter = ServiceLocator.get();
  final GenerateViewModel _viewModel = ServiceLocator.get();

  AppLocalizations get _localizations {
    return AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    _presenter.setView(this);
    _presenter.setViewModel(_viewModel);
  }

  @override
  void refreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _viewModel.password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildTitle(_localizations.password_title),
              const SizedBox(height: 8.0),
              _buildPasswordLabel(),
              const SizedBox(height: 16.0),
              _buildTitle(
                '${_localizations.length_title} (${_viewModel.length})',
              ),
              const SizedBox(height: 8.0),
              _buildLengthSlider(),
              const SizedBox(height: 16.0),
              _buildTitle(_localizations.settings_title),
              const SizedBox(height: 8.0),
              _buildUppercaseSwitch(),
              const SizedBox(height: 4.0),
              _buildLowercaseSwitch(),
              const SizedBox(height: 4.0),
              _buildNumbersSwitch(),
              const SizedBox(height: 4.0),
              _buildSymbolsSwitch(),
              const SizedBox(height: 4.0),
              _buildWordsSwitch(),
              const SizedBox(height: 16.0),
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTitle(String text) {
    return Row(
      children: <Widget>[
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordLabel() {
    return ControlContainer(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  key: const Key('test_password_label'),
                  _viewModel.password.breakWord(),
                  style: const TextStyle(fontSize: 24.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            key: const Key('test_copy_button'),
            icon: const Icon(Icons.copy_outlined, size: 36.0),
            onPressed: _viewModel.canCopy ? _presenter.copyPassword : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLengthSlider() {
    return ControlContainer(
      children: <Widget>[
        Expanded(
          child: Slider(
            key: const Key('test_length_slider'),
            value: _viewModel.length.toDouble(),
            min: MIN_PASSWORD_LENGTH.toDouble(),
            max: MAX_PASSWORD_LENGTH.toDouble(),
            label: _viewModel.length.toString(),
            inactiveColor: Colors.white54,
            onChanged: (double value) {
              _presenter.setLength(value.toInt());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUppercaseSwitch() {
    return ControlContainer(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      children: <Widget>[
        Expanded(child: Text(_localizations.uppercase_switch_title)),
        Switch(
          key: const Key('test_uppercase_switch'),
          value: _viewModel.uppercase,
          onChanged: _presenter.enableUppercase,
        )
      ],
    );
  }

  Widget _buildLowercaseSwitch() {
    return ControlContainer(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      children: <Widget>[
        Expanded(child: Text(_localizations.lowercase_switch_title)),
        Switch(
          key: const Key('test_lowercase_switch'),
          value: _viewModel.lowercase,
          onChanged: _presenter.enableLowercase,
        )
      ],
    );
  }

  Widget _buildNumbersSwitch() {
    return ControlContainer(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      children: <Widget>[
        Expanded(child: Text(_localizations.numbers_switch_title)),
        Switch(
          key: const Key('test_numbers_switch'),
          value: _viewModel.numbers,
          onChanged: _presenter.enableNumbers,
        )
      ],
    );
  }

  Widget _buildSymbolsSwitch() {
    return ControlContainer(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      children: <Widget>[
        Expanded(child: Text(_localizations.symbols_switch_title)),
        Switch(
          key: const Key('test_symbols_switch'),
          value: _viewModel.symbols,
          onChanged: _presenter.enableSymbols,
        )
      ],
    );
  }

  Widget _buildWordsSwitch() {
    return ControlContainer(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      children: <Widget>[
        Expanded(child: Text(_localizations.words_switch_title)),
        Switch(
          key: const Key('test_words_switch'),
          value: _viewModel.words,
          onChanged: _presenter.enableWords,
        )
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: FilledButton(
            key: const Key('test_generate_button'),
            onPressed:
                _viewModel.canGenerate ? _presenter.generatePassword : null,
            child: Text(_localizations.generate_button_label),
          ),
        ),
      ],
    );
  }
}
