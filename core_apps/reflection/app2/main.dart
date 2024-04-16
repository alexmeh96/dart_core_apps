import 'dart:io';
import 'dart:mirrors';

class TcpHandler {
  const TcpHandler();
}

class Server {
  Server();

  // @TcpHandler()
  void handler(String message) {
    print(message);
  }

  @TcpHandler()
  void handler2(Socket socket, String message) {
    print("!!!$message");
    socket.write("answer form server: $message\n");
  }
}

void main() async {

  var server = Server();
  var classMirror = reflect(server);

  // Поиск метода с аннотацией MyAnnotation
  MethodMirror? method = classMirror.type.instanceMembers.values.firstWhere(
        (m) => m.metadata.any((meta) => meta.reflectee is TcpHandler),
  );

  // classMirror.invoke(method.simpleName, ["Hello"]);

  var serverSocket = await ServerSocket.bind("localhost", 9999);

  serverSocket.listen((socket) {
    socket.listen((data) {
      var message = String.fromCharCodes(data).trim();
      classMirror.invoke(method.simpleName, [socket, message]);
    });
  });

}
