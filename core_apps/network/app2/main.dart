import 'dart:async';
import 'dart:collection';
import 'dart:io';

void main() async {
  ServerSocket serverSocket = await ServerSocket.bind('0.0.0.0', 9090);
  var streamController = StreamController<Event>();

  var eventQueue = Queue<Event>();



  streamController.stream.listen((event) async {
    print("get event");
    socketTask(event.payload);
  });

  serverSocket.listen(
    (Socket socket) {
      print("socket");

      socket.listen(
        (data) {
          // print("socket read");
          var event = new Event("socket read", data, socketTask);
          eventQueue.add(event);
          streamController.sink.add(event);
          // print(result.substring(0, result.length - 1));
        },
        onError: (_) {
          print("socket error");
        },
        onDone: () {
          print("socket done");
        },
      );
    },
    onDone: () {
      print("onDone");
    },
    onError: (_) => {
      print("onError"),
    },
  );
}

Future<void> socketTask(List<int> data) async {
  String result = new String.fromCharCodes(data);

  // fib(42);

  print("task: ${result}");
  var message = await Future.delayed(Duration(milliseconds: 2000), () => "remote task: ${result}");
  print(message);
}

class Event<T> {
  String type;
  T payload;
  Function callback;

  Event(this.type, this.payload, this.callback);
}


int fib(n) {
  // print("fib($n)");
  return n <= 1 ? n : fib(n - 1) + fib(n - 2);
}
