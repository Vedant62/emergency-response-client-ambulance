List<String> splitCommaSeparatedString(String input) {
  return input.split(',').map((item) => item.trim()).toList();
}
