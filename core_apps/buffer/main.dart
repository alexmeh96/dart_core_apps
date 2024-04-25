import 'dart:typed_data';

void main() {
  var uint8list = Uint8List.fromList([10, 20, 30, 40, 50]);
  var buffer = uint8list.buffer;
  var byteData = ByteData.view(buffer);

  byteData.setUint16(1, 255);
  print(uint8list.toList());

  byteData.setUint16(1, 256);
  print(uint8list.toList());

  byteData.setUint16(1, 0xff);
  print(uint8list.toList());

  byteData.setUint16(1, 0xffff);
  print(uint8list.toList());
}
