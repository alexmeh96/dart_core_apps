import 'dart:async';

// создаю стрим, чтобы использовать в примере
Stream<int> get sourceStream {
  final controller = StreamController<int>();
  Future<void>(() {
    controller
      ..add(1)
      ..add(2)
      ..add(3)
      ..close();
  });

  return controller.stream;
}

/// Примеры простых трансформаций stream
void main() async {
  await test1();
  print("---------------------------");
  await test2();
  print("---------------------------");
  await test3();
}

Future<void> test1() async {
  await sourceStream.map((value) => '* $value').forEach(print);
}

Future<void> test2() async {
  await sourceStream.asyncMap((value) async {
    await Future<void>.delayed(Duration(seconds: 1));
    return '** $value';
  }).forEach(print);
}

Future<void> test3() async {
  await sourceStream.asyncExpand((value) async* {
    await Future.delayed(Duration(seconds: 1));
    yield '# ${value}';
    await Future.delayed(Duration(seconds: 1));
    yield '## ${value}';
  }).forEach(print);
}
