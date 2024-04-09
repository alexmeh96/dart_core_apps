void main() async {
  await for (final character in allNames()) {
    print(character);
  }
}

Stream<String> maleNames() async* {
  yield 'John';
  yield 'Peter';
  yield 'Paul';
}

Stream<String> femaleNames() async* {
  yield 'Mary';
  yield 'Jane';
  yield 'Sue';
}

Stream<String> allNames() async* {
  yield* maleNames();
  yield* femaleNames();
}
