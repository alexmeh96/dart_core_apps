import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'authentication_message.dart';
import 'connection.dart';
import 'startup_message.dart';

void main(List<String> arguments) async {

  ByteDataWriter writer = ByteDataWriter();
  // ByteDataReader reader = ByteDataReader();


  var socket = await Socket.connect('127.0.0.1', 5433);

  var authenticationProcedure = AuthenticationProcedure(socket);


  socket.listen((data) {
    // reader.add(data);
    ByteDataReader reader = ByteDataReader();
    reader.add(data);
    var type = reader.readUint8();
    print(utf8.decode([type]));
    var expectedLength = reader.readUint32() - 4;

    if (type == 82) {
      var authenticationMessage = AuthenticationMessage.parse(reader, expectedLength);
      authenticationProcedure.handleMessage(authenticationMessage);
      print(utf8.decode(authenticationMessage.bytes));
    }

  });



  StartupMessage message = StartupMessage(timeZone: "UTC", database: "postgres", username: "postgres");
  message.addToBuffer(writer);

  // socket.add(request1);
  socket.add(writer.toBytes());
}


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
