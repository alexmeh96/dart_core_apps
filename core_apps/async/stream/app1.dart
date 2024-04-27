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

/// Примеры перебора элементов stream
void main() async {
  await test1();
  print("-----------------------------");
  await test2();
}

Future<void> test1() async {
  await sourceStream.forEach((element) {
    print("* $element");
  });
}

Future<void> test2() async {
  await for (final element in sourceStream) {
    print("# $element");
  }
}
