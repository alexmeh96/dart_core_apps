import 'dart:io';
import 'dart:typed_data';

import 'package:ioc/ioc.dart';

import 'two_test_service.dart';

@Component()
class OneTestService {
  int myField = 5;

  @Inject()
  TwoTestService? service;

  void method() {
    if (service != null) {
      service?.method();
    }
    print("method from OneTestService");
  }

  @TcpHandler()
  void handler(Uint8List data, Socket socket) {
    var message = String.fromCharCodes(data).trim();
    print("handler: $message");
    socket.write("handler: $message\n");
  }
}

void myFun() {

}
