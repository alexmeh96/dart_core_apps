import 'package:ioc/ioc.dart';

@Component()
class TwoTestService {

  void method() {
    print("method from twoTestService");
  }

  @Transaction()
  void transactMethod() {
    print("transactMethod");
  }
}

void myFun() {

}
