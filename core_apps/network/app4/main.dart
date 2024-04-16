import 'dart:async';
import 'dart:io';

// Сообщения между акторами
abstract class Message {}

class RequestMessage implements Message {
  final String request;

  RequestMessage(this.request);
}

class ResponseMessage implements Message {
  final String response;

  ResponseMessage(this.response);
}

// Актор обработчика запросов
class RequestHandlerActor {
  final DatabaseActor databaseActor;
  final StreamController<Message> _controller;

  RequestHandlerActor(this.databaseActor, this._controller);

  void handleRequest(String request) {
    _controller.sink.add(RequestMessage(request));
  }

  void _handleMessage(Message message) async {
    if (message is RequestMessage) {
      print('Handling request: ${message.request}');
      // Имитация обработки запроса
      await Future.delayed(Duration(seconds: 1));

      // Запрос к базе данных
      var result = await databaseActor.query(message.request);

      _controller.sink.add(ResponseMessage(result));
    }
  }

  void start() {
    _controller.stream.listen(_handleMessage);
  }
}

// Актор доступа к базе данных
class DatabaseActor {
  Future<String> query(String request) async {
    print('Querying database for request: $request');
    // Имитация запроса к базе данных
    await Future.delayed(Duration(seconds: 1));

    // Возврат результата
    return 'Result for request: $request';
  }
}

// Актор ответов
class ResponseActor {
  void sendResponse(String response, Socket clientWriter) async {
    print('Sending response: $response');
    // Отправка ответа клиенту
    clientWriter.write(response);
    await clientWriter.flush();
    // clientWriter.close();
  }
}

Future<void> main() async {
  var databaseActor = DatabaseActor();
  var controller = StreamController<Message>.broadcast();
  var requestHandlerActor = RequestHandlerActor(databaseActor, controller);
  var responseActor = ResponseActor();

  requestHandlerActor.start();

  var server = await ServerSocket.bind('127.0.0.1', 9999);

  await for (var socket in server) {

    // todo: нужно пофиксить. Отправка происходит всем сокетам
    controller.stream.listen((message) {
      if (message is ResponseMessage) {
        responseActor.sendResponse(message.response, socket);
      }
    });

    socket.listen((data) {
      requestHandlerActor.handleRequest(String.fromCharCodes(data).trim());
    });
  }
}
