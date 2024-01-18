import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import './model/Message.dart';
import './model/Payload.dart';

final Map<int, WebSocketChannel> wsChannels = {};
final Map<String, void Function(int, Payload)> wsMessageHandlers = {};

void sendMessage(int userId, Payload payload) {
  final endUserId = payload.userId;
  final chanel = wsChannels[endUserId];

  if (chanel == null) {
    print("not connected user: $userId");
  } else {
    final newMessage = Message(
        route: "message",
        payload: Payload(userId: userId, data: payload.data));
    final data = json.encode(newMessage);
    chanel.sink.add(data);
  }
}

void alertConnection(int userId, String status) {
  for (final wsChannelElement in wsChannels.entries) {
    if (wsChannelElement.key == userId) {
      final message1 = Message(
          route: "connection",
          payload: Payload(userId: userId, data: "success"));

      final message2 = Message(
          route: "users",
          payload: Payload(userId: userId, data: wsChannels.keys.toList()));

      wsChannelElement.value.sink.add(json.encode(message1));
      wsChannelElement.value.sink.add(json.encode(message2));
    } else {
      final newMessage = Message(
          route: "connection", payload: Payload(userId: userId, data: status));
      final data = json.encode(newMessage);
      wsChannelElement.value.sink.add(data);
    }
  }
}

void handlerWebSocket(WebSocketChannel wsChannel) {
  var userId = wsChannel.hashCode;
  print('Connected: $userId');
  wsChannel.stream.listen((data) {
    print("get message from userId: $userId");
    try {
      if (data is String) {
        final jsonMap = json.decode(data);
        final message = Message.fromJson(jsonMap);
        messageHandler(userId, message);
      } else if (data is List<int>) {
        print("Binary: ");
        String result = utf8.decode(data);
        final jsonMap = json.decode(result);
        final message = Message.fromJson(jsonMap);
        messageHandler(userId, message);
      }
    } catch (e) {
      print("Can not JSON serialise");
    }
  }, onDone: () {
    print('Close connection: $userId');
    wsChannel.sink.close();
    wsChannels.remove(userId);
    alertConnection(userId, "close");
  }, onError: (e) {
    print('Error connection: $userId; $e');
    wsChannel.sink.close();
    wsChannels.remove(userId);
    alertConnection(userId, "close");
  });

  wsChannels.addAll({userId: wsChannel});
  alertConnection(userId, "open");
}

void messageHandler(int userId, Message message) {
  final wsMessageHandler = wsMessageHandlers[message.route];
  if (wsMessageHandler != null) {
    wsMessageHandler(userId, message.payload);
  } else {
    print("Can not support this handler");
  }
}

Future<void> main() async {
  wsMessageHandlers.addAll({"message": sendMessage});

  Handler wsHandler = webSocketHandler(handlerWebSocket);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(wsHandler);

  final server = await serve(handler, '0.0.0.0', 8080);
  print('Server listening on port ${server.port}');
}
