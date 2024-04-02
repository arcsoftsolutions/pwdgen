import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/password_model.dart';

class PasswordViewModel {
  PasswordViewModel(this.model);

  final PasswordModel model;

  String get password => model.password;

  String getCreationDate(BuildContext context) {
    final String locale = Localizations.localeOf(context).toString();
    final DateFormat dateFormat = DateFormat.yMd(locale);
    final DateFormat hourFormat = DateFormat.Hms(locale);
    return '${dateFormat.format(model.creationDate)} ${hourFormat.format(model.creationDate)}';
  }

  bool removed = false;
}
