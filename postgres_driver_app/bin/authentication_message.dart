import 'dart:typed_data';

import 'package:buffer/buffer.dart';

abstract class AuthenticationMessageType {
  static const int ok = 0;
  static const int kerberosV5 = 2;
  static const int clearTextPassword = 3;
  static const int md5Password = 5;
  static const int scmCredential = 6;
  static const int gss = 7;
  static const int gssContinue = 8;
  static const int sspi = 9;
  static const int sasl = 10;
  static const int saslContinue = 11;
  static const int saslFinal = 12;
}

class AuthenticationMessage {
  final int type;
  late final Uint8List bytes;

  AuthenticationMessage._(this.type, this.bytes);

  factory AuthenticationMessage.parse(ByteDataReader reader, int length) {
    final type = reader.readUint32();
    return AuthenticationMessage._(type, reader.read(length - 4));
  }
}
