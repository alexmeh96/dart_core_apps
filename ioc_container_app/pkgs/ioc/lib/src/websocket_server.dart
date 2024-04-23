import 'dart:io';

import 'handlers.dart';

class WebsocketServer {
  final String host;
  final int port;

  List<MethodOption> handlers = [];

  WebsocketServer(this.host, this.port);

  void run() async {
    var httpServer = await HttpServer.bind(host, port);

    httpServer.listen((HttpRequest req) async {
      if (req.uri.path == '/ws') {
        var webSocket = await WebSocketTransformer.upgrade(req);
        webSocket.listen((data) {
          for (var handler in handlers) {
            handler.invoke([data, webSocket]);
          }
        });
      }
    });
  }

}
