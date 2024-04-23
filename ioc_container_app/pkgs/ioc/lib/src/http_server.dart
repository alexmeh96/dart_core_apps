import 'dart:io';

import 'handlers.dart';

class BaseHttpServer {
  final String host;
  final int port;

  List<MethodOption> handlers = [];

  BaseHttpServer(this.host, this.port);

  void run() async {
    var httpServer = await HttpServer.bind(host, port);

    httpServer.listen((request) {
      for (var handler in handlers) {
        handler.invoke([request]);
      }
    });
  }

}
