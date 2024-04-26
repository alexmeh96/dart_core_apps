import 'dart:convert';
import 'package:buffer/buffer.dart';

abstract class ClientMessageFormat {
  static const int text = 0;
  static const int binary = 1;
}

abstract class ClientMessageId {
  static const int bind = 66; // B
  static const int describe = 68; // D
  static const int execute = 69; // E
  static const int parse = 80; //P
  static const int query = 81; // Q
  static const int sync = 83; // S
  static const int password = 112; //p
  // static const int close = $C;
  static const int close = 0x43;
}

class StartupMessage {
  final String? _username;
  final String _databaseName;
  final String _timeZone;
  final String? _applicationName;

  StartupMessage({
    required String database,
    required String timeZone,
    String? username,
    String? applicationName,
  })  : _databaseName = database,
        _timeZone = timeZone,
        _username = username,
        _applicationName = applicationName;

  void addToBuffer(ByteDataWriter buffer) {
    Encoding e = utf8;
    final properties = [
      (e.encode('client_encoding'), e.encode(e.name)),
      (e.encode('database'), e.encode(_databaseName)),
      (e.encode('TimeZone'), e.encode(_timeZone)),
      if (_username != null) (e.encode('user'), e.encode(_username)),
      if (_applicationName != null)
        (e.encode('application_name'), e.encode(_applicationName)),
    ];

    final propertiesLength = properties
        .map((e) => e.$1.length + e.$2.length + 2)
        .fold<int>(0, (sum, x) => sum + x);

    // 4 bytes length, 4 bytes protocol version, 1 extra zero at the end
    buffer.writeInt32(propertiesLength + 4 + 4 + 1);
    // protocol version
    buffer.writeInt16(3);
    buffer.writeInt16(0);

    for (final e in properties) {
      buffer.write(e.$1);
      buffer.writeInt8(0);
      buffer.write(e.$2);
      buffer.writeInt8(0);
    }

    buffer.writeInt8(0);
  }

}
