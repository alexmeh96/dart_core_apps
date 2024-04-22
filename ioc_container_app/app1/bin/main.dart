import 'dart:mirrors';

import 'package:app1/two_test_service.dart';
import 'package:ioc/ioc.dart';

import 'test/one_test_service.dart';


void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:app1"];
  var classMirrors = ioc.findClassesFromPackages(packages);
  ioc.checkTransaction();
  var container = ioc.findComponentClasses();

  var oneTestService = container["OneTestService"] as OneTestService;
  oneTestService.method();
  print("--------------------------------");
  ioc.resolveInject();
  oneTestService.method();

  print(ioc.isInit);
}
