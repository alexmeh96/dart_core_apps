import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void handlerWebSocket(WebSocketChannel wsChannel) {
  var userId = wsChannel.hashCode;
  print('Connected: $userId');
  wsChannel.stream.listen((data) {
    print("get message from userId: $userId");
    wsChannel.sink.add(data);
  }, onDone: () {
    print('Close connection: $userId');
    wsChannel.sink.close();
  }, onError: (e) {
    print('Error connection: $userId; $e');
    wsChannel.sink.close();
  });
}


Future<void> main() async {
  Handler wsHandler = webSocketHandler(handlerWebSocket);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(wsHandler);

  final server = await serve(handler, '0.0.0.0', 8080);
  print('Server listening on port ${server.port}');
}
