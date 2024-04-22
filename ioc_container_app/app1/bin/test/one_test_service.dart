import 'package:ioc/ioc.dart';

import 'two_test_service.dart';

@Component()
class OneTestService {

  int myField = 5;

  @Inject()
  TwoTestService? service;

  void method() {
    if (service != null) {
      service?.method();
    }
    print("method from OneTestService");
  }
}

void myFun() {

}
