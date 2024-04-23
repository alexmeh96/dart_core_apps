import 'dart:io';

import 'handlers.dart';

class TcpServer {
  final String host;
  final int port;

  List<MethodOption> handlers = [];

  TcpServer(this.host, this.port);

  void run() async {
    var serverSocket = await ServerSocket.bind(host, port);

    serverSocket.listen((socket) {
      socket.listen((data) {
        for (var handler in handlers) {
          handler.invoke([socket, data]);
        }
      });
    });
  }

}
