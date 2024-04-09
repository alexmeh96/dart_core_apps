import 'dart:io';

void main() {

  final environments = Platform.environment;

  var env1 = environments['MY_VAR'];
  print("MY_VAR: $env1");

  var env2 = environments['MY_PARAM'];
  print("MY_PARAM: $env2");

}
