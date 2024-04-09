import 'dart:async';

void main() async {
  final controller = StreamController<String>();
  controller.sink.add('hello');
  controller.sink.add('world');

  await for (final value in controller.stream) {
    print(value);
  }

  controller.close();
}


