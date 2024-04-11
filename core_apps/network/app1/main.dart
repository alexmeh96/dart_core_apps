import 'dart:core';
import 'dart:io';

void startServer() async {
  ServerSocket serverSocket = await ServerSocket.bind('0.0.0.0', 9090);

  serverSocket.listen(
    (Socket socket) {
      print("socket");

      socket.listen(
        (List<int> data) {
          String result = new String.fromCharCodes(data);
          print(result.substring(0, result.length - 1));
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

void main() {
  startServer();
}
