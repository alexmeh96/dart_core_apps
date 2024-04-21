import 'dart:mirrors';

import 'package:app1/two_test_service.dart';
import 'package:ioc/ioc.dart';

import 'one_test_service.dart';


void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:app1"];
  var classMirrors = ioc.findClassesFromPackages(packages);


  print(ioc.isInit);
}
