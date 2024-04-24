import 'package:ioc/ioc.dart';

import 'components/one_test_service.dart';

void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:ioc"];
  ioc.init(packages);

  var websocketServer = WebsocketServer("localhost", 9999);
  websocketServer.handlers = ioc.methods.where((option) => option.type == MethodType.WEBSOCKET_HANDLER).toList();
  websocketServer.run();
}

