void main() async {

  method2();

  print("start");


  for (var i = 0; i < 10; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    print("method1: $i");
  }

}

Future<void> method1() async {
  for (var i = 0; i < 10; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    print("method1: $i");
  }
}

Future<void> method2() async {
  var res = fib(20);
  print("finish res = $res");
}


int fib(n) {
  print("fib($n)");
  return n <= 1 ? n : fib(n - 1) + fib(n - 2);
}


int fib2(n) {
  print("fib2($n)");

  var a = 1;
  var b = 1;
  for (var i = 3; i <= n; i++) {
    var c = a + b;
    a = b;
    b = c;
  }
  return b;
}
