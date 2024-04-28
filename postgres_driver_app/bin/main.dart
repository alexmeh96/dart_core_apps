import 'dart:convert';

import 'package:buffer/buffer.dart';

import 'connection.dart';

void main(List<String> arguments) async {
  var connection = Connection('127.0.0.1', 5433, "postgres", "password", "postgres");
  await connection.connect();
}

void main2() {
  ByteDataReader reader = ByteDataReader();

  reader.add([0]);

  var bytes = reader.readUntilTerminatingByte(0);
  var decode = utf8.decode(bytes);
  print(decode);
}

// StartupMessage (F)
List<int> request1 = [
  0, 0, 0, 41,
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
  0
];
