import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main() {
  String jwtToken = "";
  final publicKeys = {
    "526c6a84ac067005ce34ceff9b3a2e08e0dd9bcc": RSAPublicKey.cert(
        "-----BEGIN CERTIFICATE-----\nMIIDHTCCAgWgAwIBAgIJAMBcVYr/iQ/pMA0GCSqGSIb3DQEBBQUAMDExLzAtBgNV\nBAMMJnNlY3VyZXRva2VuLnN5c3RlbS5nc2VydmljZWFjY291bnQuY29tMB4XDTIz\nMTIyNDA3MzIwNVoXDTI0MDEwOTE5NDcwNVowMTEvMC0GA1UEAwwmc2VjdXJldG9r\nZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wggEiMA0GCSqGSIb3DQEBAQUA\nA4IBDwAwggEKAoIBAQCcUT9Hwk4Gr+QFvM2s/0wtqe+r8Kkih8S2vh/EA5jzsOTL\n8rJZpUViqGOKmmes/22lycBKEUTocjbjdxyz0mr5Vg+U9v8ZSJsYeL5xqhjBF/4k\nrM6OT1W0ap5oRv3fwgTkX8woIKzxHiLUJRWRkeAH+/XXRG0SZNAqd2f6ymAQ0Gl5\n0p6Q8aKw21Ob4CUaiM2FHhIsks4ROKaYKwUxVNxcx+wqA9am3SX5Q2MqL7+rgitR\nluNmc43KAM12wXh4a26/BEiEv3AfvEO1YG33oX81H1FDLUzaf7EmgKlClukDUbAJ\n6tB+Z6hKenFWdFFT501rLJ188YLj9q5BO39jWiVpAgMBAAGjODA2MAwGA1UdEwEB\n/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMCMA0G\nCSqGSIb3DQEBBQUAA4IBAQA0SSVQNTyK5KWD4LYtgbxSq+/d9Bgjwy+7sEnDGiBF\njXkRz1+YPhfNUQaHglPFY0yJTeDHuoQOTqvCzfWGl6v2+hKAjjzJzphmP4o06RpQ\nIIxDsBnUFjZ2TmOY1P0UEUtN6PmlWwZrePifoNeXhAMWeS2XkGNg7JVOWeZbGO+L\n8GQIiO4xYwshou2tuPwzv4VcReO2s5Vx4HxsqOQqDAcAB3W5tu/kSEHXTh9Vtb8D\n7D78BfSDsQdD3+7PvppOReUpYSPGpqH7DaLuGaoFVFTWiyzFkyWTObFZLNpH916L\nHadlHL1FGEztDVY6TRDeob0XELl9M85Y1NfB4M4wLkX8\n-----END CERTIFICATE-----\n"),
    "d1689415ec23a337e2bbaa5e3e68b66dc9936884": RSAPublicKey.cert(
        "-----BEGIN CERTIFICATE-----\nMIIDHTCCAgWgAwIBAgIJALUunHvokterMA0GCSqGSIb3DQEBBQUAMDExLzAtBgNV\nBAMMJnNlY3VyZXRva2VuLnN5c3RlbS5nc2VydmljZWFjY291bnQuY29tMB4XDTI0\nMDEwMTA3MzIwNloXDTI0MDExNzE5NDcwNlowMTEvMC0GA1UEAwwmc2VjdXJldG9r\nZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wggEiMA0GCSqGSIb3DQEBAQUA\nA4IBDwAwggEKAoIBAQCiJ4CCXrGGh0pfH60RxPyl6qSCn4fBFH7YZ5CMaMTYFKvg\n7MAIaOygQaSc0iDkigVF+6qmDqgkvm+HJFnPFHaVOeB20DLpzRXW50S4AhBU0HUs\npAu+NRAjBoqeODyBiNBjiaoqmHoltSuVVaE3qrKTdHaApfZ0OGw62txx7hzzoYQO\n0J2/BoZVkjoKyU0f5tUxVMlUN1UwACXjPd6VSiM1iYBaZ5UannvjmwzNp7eXYnm0\nylVLdypN3HYYlKjjLFIWmCLGItfoVE67/4Cm/H8b2aP3HJgCCc7qQN2+VA1aasl9\n9l5WgzcwvNYhVWfz3eqUgqy+bSDmpmzHofAvwBsVAgMBAAGjODA2MAwGA1UdEwEB\n/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMCMA0G\nCSqGSIb3DQEBBQUAA4IBAQCLcknZv527sAryfBnemO14+wsNQg5oWCE3WLcS5KQZ\noJpfXG83YGNbfbJqgQX8BG+e2mRp0K3XqpHFbyqkfyhJm4mM5xzzGuVS71DO3Jb7\np2m9pabSPodhmCT8FPXNb4Ms4oqlaDJ5gzXVij6CYE6GA+FystELNXVtoNM5WfI9\nhJVvm5UA07Kw42rp+apTrSTfni2jMpHq/gKiXxJHB/M98pPf3kgXzr4dKN0Xdra2\nrCywvsYnSmBfDBfSuXFpITW+q+3UqtLWq6v01coXxfG7+s/fEeGhpVaby/4YVvCv\nZamW2WUiDUktVUbnIKTjJiqCo5kOBlguX1yyJmJSd/1t\n-----END CERTIFICATE-----\n")
  };

  try {
    var jwt = JWT.decode(jwtToken);
    var kid = jwt.header?["kid"];
    var publicKey = publicKeys[kid];

    var jwtVerified = JWT.verify(jwtToken, publicKey!);

    print('Payload: ${jwtVerified.payload}');
  } on JWTExpiredException {
    print('jwt expired');
  } on JWTException catch (ex) {
    print(ex.message); // ex: invalid signature
  }
}
