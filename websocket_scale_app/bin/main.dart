import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:redis/redis.dart';


final Map<int, WebSocketChannel> wsChannels = {};

late final RedisConnection connection;
late final Command command;

late final RedisConnection pubSubConn;
late final Command pubSubCommand;
late final PubSub pubSub;


void handlerWebSocket(WebSocketChannel wsChannel) async {
  var userId = wsChannel.hashCode;
  print('Connected: $userId');
  wsChannel.sink.add("connected on host: $myHost");


  wsChannel.stream.listen((data) async {
    print("get message from userId: $userId");
    try {
      if (data is String) {
        command.send_object(["PUBLISH","TOPIC_1", data]);
      }
    } catch (e) {
      print("Can not JSON serialise");
    }
  }, onDone: () {
    print('Close connection: $userId');
    wsChannel.sink.close();
    wsChannels.remove(userId);
  }, onError: (e) {
    print('Error connection: $userId; $e');
    wsChannel.sink.close();
    wsChannels.remove(userId);
  });



  wsChannels.addAll({userId: wsChannel});
}

final myHost = Platform.environment['MY_HOST'];


Future<void> main() async {

  final redisHost = Platform.environment['REDIS_HOST'] ?? 'localhost';
  connection = RedisConnection();
  command = await connection.connect(redisHost, 6379);

  pubSubConn = RedisConnection();
  pubSubCommand = await pubSubConn.connect(redisHost, 6379);
  pubSub = PubSub(pubSubCommand);

  pubSub.subscribe(["TOPIC_1"]);

  pubSub.getStream().handleError((e) => print("error: $e")).listen((message) {
    print("!!!");
    print(message);

    for (final chanel in wsChannels.values) {
      chanel.sink.add(message[2]);
    }
  });

  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  Handler wsHandler = webSocketHandler(handlerWebSocket);
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(wsHandler);
  final server = await serve(handler, '0.0.0.0', port);
  print('Server listening on port ${server.port}');
}
