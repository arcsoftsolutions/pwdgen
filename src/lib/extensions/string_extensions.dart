extension StringExtensions on String {
  String breakWord() {
    String result = '';
    for (final int element in runes) {
      result += String.fromCharCode(element);
      result += '\u200B';
    }
    return result;
  }
}
