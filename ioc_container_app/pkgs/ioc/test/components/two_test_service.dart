import 'dart:io';
import 'dart:typed_data';

import 'package:ioc/ioc.dart';

@Component()
class TwoTestService {

  void method() {
    print("method from twoTestService");
  }

  void transactMethod() {
    print("transactMethod");
  }

  @TcpHandler()
    void tcpHandler(Uint8List data, Socket socket) {
    var message = String.fromCharCodes(data).trim();
    print("tcpHandler: $message");
  }

  @TcpHandler()
  void tcpHandler2(Uint8List data, Socket socket) {
    var message = String.fromCharCodes(data).trim();
    print("tcpHandler2: $message");

    socket.write("tcpHandler2: $message\n");
  }

  @WebsocketHandler()
  void websocketHandler(dynamic message, WebSocket socket) {
    print("tcpHandler2: $message");

    socket.add("tcpHandler2: $message\n");
  }

  @HttpHandler()
  void httpHandler(HttpRequest req) {
    print("httpHandler: ${req.method}: ${req.uri.path}");

    HttpResponse res = req.response;
    res.write('Response from server\n');
    res.close();
  }

  // @HttpHandler()
  void httpHandler2(HttpRequest req) {
    print("httpHandler2: ${req.method}: ${req.uri.path}");

    HttpResponse res = req.response;
    res.write('Response from server\n');
    res.close();
  }
}

void myFun() {

}
