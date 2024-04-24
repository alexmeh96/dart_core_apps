import 'package:ioc/ioc.dart';

import 'components/one_test_service.dart';

void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:ioc"];
  ioc.init(packages);

  var tcpServer = TcpServer("localhost", 9999);
  tcpServer.handlers = ioc.methods.where((option) => option.type == MethodType.TCP_HANDLER).toList();
  tcpServer.run();
}
