import 'package:flutter/foundation.dart';

@immutable
class PasswordModel {
  PasswordModel(this.password) {
    creationDate = DateTime.now();
  }

  PasswordModel.fromJson(Map<String, dynamic> json)
      : password = json['password'] as String,
        creationDate = DateTime.fromMillisecondsSinceEpoch(
          json['creation_date'] as int,
        );

  final String password;
  late final DateTime creationDate;

  @override
  int get hashCode => password.hashCode;

  @override
  bool operator ==(Object other) {
    return other is PasswordModel && other.password == password;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'password': password,
      'creation_date': creationDate.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return password;
  }
}
