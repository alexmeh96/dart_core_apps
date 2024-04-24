import 'package:ioc/ioc.dart';

import 'components/one_test_service.dart';

void main() {
  Ioc ioc = Ioc();
  List<String> packages = ["file://", "package:ioc"];
  ioc.findClassesFromPackages(packages);
  ioc.findComponentClasses();

  var oneTestService = ioc.container["OneTestService"] as OneTestService;
  oneTestService.method();
  print("--------------------------------");
  ioc.resolveDependencies();
  oneTestService.method();
}
