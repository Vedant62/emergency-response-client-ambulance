String generateAmbulanceId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36); // Base-36 timestamp
  final randomPart = List.generate(4, (_) => _randomChar()).join(); // 4 random characters
  return 'AMB-$timestamp-$randomPart';
}

String _randomChar() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789'; // Base-36 characters
  final randomIndex = DateTime.now().microsecondsSinceEpoch % chars.length;
  return chars[randomIndex];
}

String generateCaseId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36); // Base-36 timestamp
  final randomPart = List.generate(4, (_) => _randomChar()).join(); // 4 random characters
  return 'CASE-$timestamp-$randomPart';
}
