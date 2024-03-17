class PasswordGeneratorViewModel {
  int length = 12;
  bool uppercase = true;
  bool lowercase = true;
  bool numbers = true;
  bool symbols = false;
  String password = '';
  bool get canGenerate => uppercase || lowercase || numbers || symbols;
  bool get canCopy => password.isNotEmpty;
}
