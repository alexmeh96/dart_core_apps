void main() async {
  final resultStream = getNames().asyncExpand((name) => getCharacters(name));

  await for (final character in resultStream) {
    print(character);
  }
}

Stream<String> getCharacters(String fromString) async* {
  for (var i = 0; i < fromString.length; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield fromString[i];
  }
}

Stream<String> getNames() async* {
  yield 'alex';
  await Future.delayed(Duration(seconds: 3));
  yield 'meh';
}
