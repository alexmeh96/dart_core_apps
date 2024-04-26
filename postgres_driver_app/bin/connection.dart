import 'dart:io';

import 'package:sasl_scram/sasl_scram.dart';
import 'package:crypto/crypto.dart';

import 'authentication_message.dart';
import 'sasl_authenticator.dart';

enum AuthenticationScheme {
  md5,
  scramSha256,
  clear,
}

class AuthenticationProcedure  {
  Socket socket;
  late PgSaslAuthenticator _authenticator;

  AuthenticationProcedure(this.socket);

  Future<void> handleMessage(AuthenticationMessage message) async {
      switch (message.type) {
        case AuthenticationMessageType.ok:
          print("Connect!");
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

  void handleAuth(AuthenticationMessage message, AuthenticationScheme scheme) {
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


