class GenerateViewModel {
  int length = 12;
  bool uppercase = true;
  bool lowercase = true;
  bool numbers = true;
  bool symbols = false;
  bool words = false;
  String password = '';
  bool get canGenerate => uppercase || lowercase || numbers || symbols || words;
  bool get canCopy => password.isNotEmpty;
}
