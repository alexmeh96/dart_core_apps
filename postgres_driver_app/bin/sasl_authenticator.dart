import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:sasl_scram/sasl_scram.dart';

import 'authentication_message.dart';
import 'startup_message.dart';

class PgSaslAuthenticator {
  final SaslAuthenticator authenticator;
  Socket socket;

  PgSaslAuthenticator(this.authenticator, this.socket);

  void onMessage(AuthenticationMessage message) {
    var writer = ByteDataWriter();
    switch (message.type) {
      case AuthenticationMessageType.sasl:
        final bytesToSend = authenticator.handleMessage(
            SaslMessageType.AuthenticationSASL, message.bytes);
        if (bytesToSend == null) {
          throw('KindSASL: No bytes to send');
        }
        var msg = SaslClientFirstMessage(bytesToSend, authenticator.mechanism.name);
        msg.addToBuffer(writer);
        break;
      case AuthenticationMessageType.saslContinue:
        final bytesToSend = authenticator.handleMessage(
            SaslMessageType.AuthenticationSASLContinue, message.bytes);
        if (bytesToSend == null) {
          throw('KindSASLContinue: No bytes to send');
        }
        var msg = SaslClientLastMessage(bytesToSend);
        msg.addToBuffer(writer);
        break;
      case AuthenticationMessageType.saslFinal:
        authenticator.handleMessage(
            SaslMessageType.AuthenticationSASLFinal, message.bytes);
        return;
      default:
        throw('Unsupported authentication type ${message.type}, closing connection.');
    }
    socket.add(writer.toBytes());
  }
}

class SaslClientFirstMessage {
  final Uint8List bytesToSendToServer;
  final String mechanismName;

  SaslClientFirstMessage(this.bytesToSendToServer, this.mechanismName);

  void addToBuffer(ByteDataWriter buffer) {
    buffer.writeUint8(ClientMessageId.password);

    final encodedMechanismName = utf8.encode(mechanismName);
    final msgLength = bytesToSendToServer.length;
    // No Identifier bit + 4 byte counts (for whole length) + mechanism bytes + zero byte + 4 byte counts (for msg length) + msg bytes
    final length = 4 + encodedMechanismName.length + 1 + 4 + msgLength;

    buffer.writeUint32(length);
    buffer.write(encodedMechanismName);
    buffer.writeInt8(0);

    // do not add the msg byte count for whatever reason
    buffer.writeUint32(msgLength);
    buffer.write(bytesToSendToServer);
  }
}

class SaslClientLastMessage {
  Uint8List bytesToSendToServer;

  SaslClientLastMessage(this.bytesToSendToServer);

  void addToBuffer(ByteDataWriter buffer) {
    buffer.writeUint8(ClientMessageId.password);

    // No Identifier bit + 4 byte counts (for msg length) + msg bytes
    final length = 4 + bytesToSendToServer.length;

    buffer.writeUint32(length);
    buffer.write(bytesToSendToServer);
  }
}
