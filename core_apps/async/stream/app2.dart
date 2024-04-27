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

void main() async {
  test1();
  print("----------------------------------");
  await test2();
  print("----------------------------------");
  await test3();
}

/// Пример синхронного итератора Iterator
void test1() {
  final list = <String>['a', 'b', 'c'];
  Iterator<String> syncIter = list.iterator;
  while (syncIter.moveNext()) {
    print(syncIter.current);
  }
}

/// Пример асинхронного итератора StreamIterator
Future<void> test2() async {
  final iter = StreamIterator<int>(sourceStream);
  while (await iter.moveNext()) {
    print(iter.current);
  }
}

/// Пример асинхронного итератора StreamIterator в цикле через лямда-функцию
Future<void> test3() async {
  final iter = StreamIterator<int>(sourceStream);
  await Future.doWhile(() async {
    final result = await iter.moveNext();
    if (result) {
      print(iter.current);
    }
    return result;
  });
}
