import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

void main(List<String> arguments) async {
  var socket = await Socket.connect('127.0.0.1', 5433);
  socket.listen((event) {
    print(event);
  });

  // StartupMessage (F)
  List<int> request1 = [0, 0, 0, 41,
                    //196608
                    0, 3, 0, 0,
                    //user
                    117, 115, 101, 114, 0,
                    //postgres
                    112, 111, 115, 116, 103, 114, 101, 115, 0,
                    //database
                    100, 97, 116, 97, 98, 97, 115, 101, 0,
                    //postgres
                    112, 111, 115, 116, 103, 114, 101, 115, 0,
                    0];

  socket.add(request1);
}
