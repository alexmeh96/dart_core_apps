import 'dart:convert';
import 'dart:typed_data';

void main() {
  // Целое число
  // int number = 196608;
  int number = 26;

  String str = "database";
  print(str.codeUnits);

  List<int> answer = [83, 67, 82, 65, 77, 45, 83, 72, 65, 45, 50, 53, 54];

  print(utf8.decode(answer));

  // Создание ByteData для хранения байтов
  ByteData byteData = ByteData(4);  // 2 байта для целого числа

  // Запись целого числа в ByteData (большой порядок)
  byteData.setInt32(0, number);

  // Получение массива байтов из ByteData
  Uint8List byteArray = byteData.buffer.asUint8List();


  print("Массив байтов (большой порядок): $byteArray");

}
