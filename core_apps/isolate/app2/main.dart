import 'dart:async';
import 'dart:isolate';
import 'dart:math';

void main() async {
  final worker = Worker();
  await worker.spawn();

  worker.makeUpperCase("hello1");
  worker.makeUpperCase("hello2");
  worker.makeUpperCase("hello3");
  worker.makeUpperCase("hello4");
}

class Worker {

  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();

  // функциональность для создания worker-изолята
  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  // Обрабатывать сообщения, отправленные обратно из worker-изолята
  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    } else if (message is String) {
      print("get message from worker isolate: $message");

    }
  }

  // код, который должен быть выполнен в worker-изоляте
  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      if (message is String) {
        print("get message from main isolate: $message");
        await Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 1000));
        var upperCase = message.toUpperCase();
        port.send(upperCase);
      }
    });
  }

  // общедоступный метод, который можно использовать для отправки сообщений worker-изоляту
  Future<void> makeUpperCase(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
}
