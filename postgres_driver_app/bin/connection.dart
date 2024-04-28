import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:crypto/crypto.dart';
import 'package:sasl_scram/sasl_scram.dart';

import 'client_message.dart';
import 'sasl_authenticator.dart';
import 'server_message.dart';


class Connection {
  ByteDataWriter _writer = ByteDataWriter();
  ByteDataReader _reader = ByteDataReader();

  String host;
  int port;
  String username;
  String password;
  String database;

  late Socket socket;
  late AuthProcedure _authProcedure;

  final _messageQueue = Queue<ServerMessage>();
  final _parameters = <String, String>{};

  int? _type = null;
  int _expectedLength = 0;

  Connection(this.host, this.port, this.username, this.password, this.database);

  Future<void> connect() async {
    socket = await Socket.connect(host, port);

    var subscription = socket.listen((data) {
      _handleDataFromServer(data);
    });

    _startup();
  }

  void _handleDataFromServer(Uint8List data) {
    _parseMessages(data);
    _handleMessages();
  }

  _parseMessages(Uint8List data) {
    _reader.add(data);

    while (true) {
      if (_type == null && _reader.remainingLength >= 5) {
        _type = _reader.readUint8();
        _expectedLength = _reader.readUint32() - 4;

        // print(utf8.decode([_type!]));
        // print(_expectedLength);
      }


      if (_type != null && (_expectedLength == 0 || _expectedLength <= _reader.remainingLength)) {
        ServerMessage? message;

        final targetRemainingLength = _reader.remainingLength - _expectedLength;

        if (_type == 75) {
          message = BackendKeyMessage.parse(_reader);
        } else if (_type == 82) {
          message = AuthMessage.parse(_reader, _expectedLength);
        } else if (_type == 83) {
          message = ParameterStatusMessage.parse(_reader);
        } else if (_type == 90) {
          message = ReadyForQueryMessage.parse(_reader, _expectedLength);
        } else {
          throw Exception("Not know server message with type $_type");
        }

        if (_reader.remainingLength < targetRemainingLength) {
          throw StateError('Message parser consumed more bytes than expected. type=$_type expectedLength=$_expectedLength');
        }

        _messageQueue.add(message);
        _type = null;
        _expectedLength = 0;

        continue;
      }
      break;
    }
  }

  _handleMessages() {
    //todo: проконтролировать, чтобы при обработки очереди, туд не добавлялись сообщения
    while(_messageQueue.isNotEmpty) {
      var message = _messageQueue.removeFirst();

      if (message is ParameterStatusMessage) {
        _parameters[message.name] = message.value;
      } else if (message is BackendKeyMessage) {
        //todo: ignore
      } else if (message is AuthMessage) {
        // print(utf8.decode(message.bytes));
        _authProcedure.handleMessage(message);
      } else if (message is ReadyForQueryMessage) {
        // _done.complete();
        print("ready to query!");
      }
    }
  }

  void _startup() {
    _authProcedure = AuthProcedure(socket);
    var message = StartupMessage(timeZone: "UTC", database: database, username: username);
    message.addToBuffer(_writer);

    socket.add(_writer.toBytes());
  }
}


enum AuthenticationScheme {
  md5,
  scramSha256,
  clear,
}

class AuthProcedure  {
  Socket socket;
  late PgSaslAuthenticator _authenticator;

  AuthProcedure(this.socket);

  Future<void> handleMessage(AuthMessage message) async {
    switch (message.type) {
        case AuthenticationMessageType.ok:
          print("Connected!");
          break;
        case AuthenticationMessageType.md5Password:
          handleAuth(message, AuthenticationScheme.md5);
          break;
        case AuthenticationMessageType.sasl:
          handleAuth(message, AuthenticationScheme.scramSha256);
          break;
        case AuthenticationMessageType.saslContinue:
        case AuthenticationMessageType.saslFinal:
          _authenticator.onMessage(message);
          break;
        default:
          throw('Unhandled auth mechanism');
      }
  }

  void handleAuth(AuthMessage message, AuthenticationScheme scheme) {
    switch (scheme) {
      case AuthenticationScheme.md5:
      // todo: md5
      case AuthenticationScheme.scramSha256:
        final credentials = UsernamePasswordCredential(username: "postgres", password: "password");
        _authenticator= PgSaslAuthenticator(ScramAuthenticator('SCRAM-SHA-256', sha256, credentials), socket);
        _authenticator.onMessage(message);
      case AuthenticationScheme.clear:
      // todo: clear
    }
  }
}


