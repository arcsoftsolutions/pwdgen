import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'password_generator_module.dart';
import 'password_generator_presenter.dart';
import 'password_generator_view.dart';
import 'password_generator_view_model.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() {
    return PasswordGeneratorPageState();
  }
}

class PasswordGeneratorPageState extends State<PasswordGeneratorPage>
    implements PasswordGeneratorView {
  final PasswordGeneratorPresenter _presenter = PasswordGeneratorModule.get();
  late PasswordGeneratorViewModel _viewModel = PasswordGeneratorViewModel();

  AppLocalizations get _localizations {
    return AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    _presenter.setView(this);
  }

  @override
  void refreshView(PasswordGeneratorViewModel viewModel) {
    setState(() {
      _viewModel = viewModel;
    });
  }

  @override
  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _viewModel.password));
    whenMounted(() => _showMessage(_localizations.copy_success_message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                const SizedBox(height: 64.0),
                _buildPasswordLabel(),
                const SizedBox(height: 32.0),
                _buildLengthSlider(),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    _buildUppercaseCheckbox(),
                    _buildLowercaseCheckbox(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildNumbersCheckbox(),
                    _buildSymbolsCheckbox(),
                  ],
                ),
                const SizedBox(height: 32.0),
                Row(
                  children: <Widget>[
                    _buildGenerateButton(),
                    const SizedBox(width: 16.0),
                    _buildCopyButton()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Image.asset('assets/logo.png'),
    );
  }

  Widget _buildPasswordLabel() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            _viewModel.password.isNotEmpty
                ? _viewModel.password
                : _localizations.password_empty_text,
            textScaler: const TextScaler.linear(1.5),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        )
      ],
    );
  }

  Widget _buildLengthSlider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Slider(
            key: const Key('length-slider'),
            value: _viewModel.length.toDouble(),
            min: 1,
            max: 50,
            label: _viewModel.length.toString(),
            onChanged: (double value) {
              _presenter.setLength(value.toInt());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUppercaseCheckbox() {
    return Expanded(
      child: CheckboxListTile(
        key: const Key('uppercase-checkbox'),
        title: Text(_localizations.uppercase_checkbox_title),
        value: _viewModel.uppercase,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? value) {
          _presenter.enableUppercase(value ?? false);
        },
      ),
    );
  }

  Widget _buildLowercaseCheckbox() {
    return Expanded(
      child: CheckboxListTile(
        key: const Key('lowercase-checkbox'),
        title: Text(_localizations.lowercase_checkbox_title),
        value: _viewModel.lowercase,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? value) {
          _presenter.enableLowercase(value ?? false);
        },
      ),
    );
  }

  Widget _buildNumbersCheckbox() {
    return Expanded(
      child: CheckboxListTile(
        key: const Key('numbers-checkbox'),
        title: Text(_localizations.numbers_checkbox_title),
        value: _viewModel.numbers,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? value) {
          _presenter.enableNumbers(value ?? false);
        },
      ),
    );
  }

  Widget _buildSymbolsCheckbox() {
    return Expanded(
      child: CheckboxListTile(
          key: const Key('symbols-checkbox'),
          title: Text(_localizations.symbols_checkbox_title),
          value: _viewModel.symbols,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            _presenter.enableSymbols(value ?? false);
          }),
    );
  }

  Widget _buildGenerateButton() {
    return Expanded(
      child: FilledButton.icon(
        key: const Key('generate-button'),
        icon: const Icon(Icons.refresh),
        label: Text(_localizations.generate_button_label),
        onPressed: _viewModel.canGenerate ? _presenter.generatePassword : null,
      ),
    );
  }

  Widget _buildCopyButton() {
    return Expanded(
      child: FilledButton.icon(
        key: const Key('copy-button'),
        icon: const Icon(Icons.copy),
        label: Text(_localizations.copy_button_label),
        onPressed: _viewModel.canCopy ? _presenter.copyPassword : null,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void whenMounted(void Function() callback) {
    if (mounted) {
      callback();
    }
  }
}
