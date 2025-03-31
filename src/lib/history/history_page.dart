import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/string_extensions.dart';
import '../l10n/app_localizations.dart';
import '../services/service_locator.dart';
import '../shared/bottom_navigation_page.dart';
import '../shared/control_container.dart';
import 'history_presenter.dart';
import 'history_view.dart';
import 'history_view_model.dart';
import 'password_view_model.dart';

class HistoryPage extends StatefulWidget implements BottomNavigationPage {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => HistoryPageState();

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context)!.history_page_title;
  }

  @override
  Icon getIcon() {
    return const Icon(Icons.schedule_rounded);
  }
}

class HistoryPageState extends State<HistoryPage> implements HistoryView {
  final HistoryPresenter _presenter = ServiceLocator.get();
  final HistoryViewModel _viewModel = ServiceLocator.get();
  final GlobalKey<AnimatedListState> _animatedList = GlobalKey();

  AppLocalizations get _localizations {
    return AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    _presenter.setView(this);
    _presenter.setViewModel(_viewModel);
    _presenter.load();
  }

  @override
  void refreshView() {
    if (mounted) {
      _updatePasswordList();
      setState(() {});
    }
  }

  @override
  Future<void> copyToClipboard(String password) async {
    await Clipboard.setData(ClipboardData(text: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _buildPasswordList(),
        _buildNoPasswordMessage(),
      ],
    );
  }

  Widget _buildPasswordList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedList(
        key: _animatedList,
        initialItemCount: _viewModel.passwords.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          final PasswordViewModel password = _viewModel.passwords[index];
          return _buildPasswordListItem(password, index, animation);
        },
      ),
    );
  }

  Widget _buildPasswordListItem(
    PasswordViewModel password,
    int index,
    Animation<double> animation,
  ) {
    return SizeTransition(
      key: ValueKey<String>(password.password),
      sizeFactor: animation,
      child: ControlContainer(
        height: 90.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        key: const Key('test_password_label'),
                        password.password.breakWord(),
                        style: const TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.schedule_rounded, size: 20.0),
                      const SizedBox(width: 8.0),
                      Text(password.getCreationDate(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            key: const Key('test_password_remove_button'),
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              size: 32.0,
              color: Colors.red.shade900,
            ),
            onPressed: () async {
              if (await _presenter.removePassword(password)) {
                _animatedList.currentState?.removeItem(
                  index,
                  duration: Durations.short4,
                  (BuildContext context, Animation<double> animation) {
                    return _buildPasswordListItem(password, index, animation);
                  },
                );
              }
            },
          ),
          IconButton(
            key: const Key('test_password_copy_button'),
            icon: const Icon(Icons.copy_outlined, size: 32.0),
            onPressed: () async {
              await _presenter.copyPassword(password);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoPasswordMessage() {
    return AnimatedOpacity(
      duration: Durations.short4,
      opacity: _viewModel.passwords.isEmpty ? 1.0 : 0.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning_rounded,
              size: 56.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8.0),
            Text(
              key: const Key('test_no_password_message'),
              _localizations.no_password_message,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePasswordList() async {
    final AnimatedListState? state = _animatedList.currentState;
    if (state == null) {
      return;
    }

    final List<PasswordViewModel> passwords = _viewModel.passwords;
    if (passwords.length <= state.widget.initialItemCount) {
      return;
    }

    int index = state.widget.initialItemCount;
    int length = passwords.length - state.widget.initialItemCount;

    while (length > 0 && state.mounted) {
      state.insertItem(index);
      await Future<void>.delayed(Durations.medium2);
      index++;
      length--;
    }
  }
}
