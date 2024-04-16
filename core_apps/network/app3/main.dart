import 'dart:async';
import 'dart:io';

// Актор обработчика запросов
class RequestHandlerActor {
  final DatabaseActor databaseActor;

  RequestHandlerActor(this.databaseActor);

  Future<String> handleRequest(String request) async {
    print('Handling request: $request');
    // Имитация обработки запроса
    await Future.delayed(Duration(seconds: 1));
    // Запрос к базе данных
    var result = await databaseActor.query(request);

    return result;
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
  Future<void> sendResponse(String response, Socket clientWriter) async {
    print('Sending response: $response');
    // Отправка ответа клиенту
    clientWriter.write(response);
    await clientWriter.flush();
    clientWriter.close();
  }
}

Future<void> handleClient(Socket clientReader, Socket clientWriter) async {
  // Создание актора базы данных
  var databaseActor = DatabaseActor();

  // Создание актора обработчика запросов
  var requestHandlerActor = RequestHandlerActor(databaseActor);

  // Чтение запроса от клиента
  clientReader.listen((data) async {
    var request = String.fromCharCodes(data);
    // Обработка запроса
    var response = await requestHandlerActor.handleRequest(request);

    // Отправка ответа клиенту
    var responseActor = ResponseActor();
    responseActor.sendResponse(response, clientWriter);
  });
}

Future<void> main() async {
  var serverSocket = await ServerSocket.bind("localhost", 9999);

  serverSocket.listen((socket) {
    handleClient(socket, socket);
  });
}
