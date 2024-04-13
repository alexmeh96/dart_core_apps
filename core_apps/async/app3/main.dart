import 'dart:async';

void main() {
  var controller = StreamController<String>();
  getTask(controller);
  addTask(controller);
}

Future<void> getTask(StreamController<String> controller) async {
  controller.stream.listen((event) async {
    await Future.delayed(Duration(milliseconds: 1500));
    print("event: ${event}");
  });
}


Future<void> addTask(StreamController<String> controller) async {
  for (int i = 0; i < 5; i++) {
    print("send: ${i}");
    controller.sink.add("${i}");
    await Future.delayed(Duration(milliseconds: 500));
  }
}
