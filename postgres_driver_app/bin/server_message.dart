import 'dart:convert';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';

// typedef _ServerMessageFn = ServerMessage Function(
//     ByteDataReader reader, int length);
//
// Map<int, _ServerMessageFn> _messageTypeMap = {
//   75: (r, _) => BackendKeyMessage.parse(r),
//   82: AuthMessage.parse,
//   83: (r, l) => ParameterStatusMessage.parse(r),
//   90: ReadyForQueryMessage.parse,
// };

class ServerMessage {}

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

class AuthMessage extends ServerMessage {
  final int type;
  late final Uint8List bytes;

  AuthMessage._(this.type, this.bytes);

  factory AuthMessage.parse(ByteDataReader reader, int length) {
    final type = reader.readUint32();
    return AuthMessage._(type, reader.read(length - 4));
  }
}

class ParameterStatusMessage extends ServerMessage {
  final String name;
  final String value;

  ParameterStatusMessage._(this.name, this.value);

  factory ParameterStatusMessage.parse(ByteDataReader reader) {
    final name = utf8.decode(reader.readUntilTerminatingByte(0));
    final value = utf8.decode(reader.readUntilTerminatingByte(0));
    return ParameterStatusMessage._(name, value);
  }
}

// abstract class ReadyForQueryMessageState {
//   static const String idle = 'I';
//   static const String transaction = 'T';
//   static const String error = 'E';
// }

class ReadyForQueryMessage extends ServerMessage {
  final String state;

  ReadyForQueryMessage.parse(ByteDataReader reader, int length)
      : state = utf8.decode(reader.read(length));

  @override
  String toString() {
    return 'ReadyForQueryMessage(state = $state)';
  }
}

class BackendKeyMessage extends ServerMessage {
  final int processId;
  final int secretKey;

  BackendKeyMessage._(this.processId, this.secretKey);

  factory BackendKeyMessage.parse(ByteDataReader reader) {
    final processId = reader.readUint32();
    final secretKey = reader.readUint32();
    return BackendKeyMessage._(processId, secretKey);
  }
}
