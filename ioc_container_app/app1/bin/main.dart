import 'dart:mirrors';

import 'package:app1/two_test_service.dart';
import 'package:ioc/ioc.dart';

import 'test/one_test_service.dart';


void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:app1"];
  ioc.init(packages);

  // var container = ioc.findComponentClasses();
  // var oneTestService = container["OneTestService"] as OneTestService;
  // oneTestService.method();
  // print("--------------------------------");
  // ioc.resolveInject();
  // oneTestService.method();

  // var tcpServer = TcpServer("localhost", 9999);
  // tcpServer.handlers = ioc.methods;
  // tcpServer.run();

  var baseHttpServer = BaseHttpServer("localhost", 9999);
  baseHttpServer.handlers = ioc.methods.where((option) => option.type == MethodType.HTTP_HANDLER).toList();
  baseHttpServer.run();

  print(ioc.isInit);
}
