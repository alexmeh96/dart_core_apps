import 'dart:io';
import 'dart:typed_data';

import 'package:ioc/ioc.dart';

@Component()
class TwoTestService {

  void method() {
    print("method from twoTestService");
  }

  @Transaction()
  void transactMethod() {
    print("transactMethod");
  }

  @TcpHandler()
    void tcpHandler(Socket socket, Uint8List data) {
    var message = String.fromCharCodes(data).trim();
    print("tcpHandler: $message");
  }

  @TcpHandler()
  void tcpHandler2(Socket socket, Uint8List data) {
    var message = String.fromCharCodes(data).trim();
    print("tcpHandler2: $message");

    socket.write("tcpHandler2: $message\n");
  }
}

void myFun() {

}
