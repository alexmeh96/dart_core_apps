import 'dart:async';
import 'dart:io';

void main() async {
  EventLoop().run();
}


Future<void> delay() async {
  print("delay: 1");
  return Future.delayed(Duration(seconds: 1), () => print("delay: 2"));
}

class EventLoop {
  var client = HttpClient();

  void run() async {
    while (true) {
      print("loop 1");
      delay();
      print("loop2");

      client.get('jsonplaceholder.typicode.com', 80, '/todos/1').then((request) => {
        request.close().then((response)  {
          print("response");
          print(response);
        })
      });

      await Future.delayed(Duration(seconds: 1));
    }
  }
}
