import 'package:ioc/ioc.dart';

import 'components/one_test_service.dart';

void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:ioc"];
  ioc.init(packages);

  var baseHttpServer = BaseHttpServer("localhost", 9999);
  baseHttpServer.handlers = ioc.methods.where((option) => option.type == MethodType.HTTP_HANDLER).toList();
  baseHttpServer.run();
}

