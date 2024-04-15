import 'dart:async';
import 'dart:io';
import 'dart:isolate';


void main() async {
  Isolate.run(() => fun1("1"));
  // Future.delayed(Duration.zero, fun1);

  while (true) {
    print("main");
    sleep(Duration(milliseconds: 500));
    // await Future.delayed(Duration(milliseconds: 1500));
  }

}

void fun1(String i) async {
  while (true) {
    print("fun$i");
    sleep(Duration(milliseconds: 1000));
    // await Future.delayed(Duration(milliseconds: 1000));
  }

}
