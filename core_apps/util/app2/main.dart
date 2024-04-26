import 'dart:convert';

void main() {
  // var str = "Hello";
  var str = "Привет!";

  var encode = utf8.encode(str);
  print(encode.toList());

  var decode = utf8.decode(encode);
  print(decode);
}
