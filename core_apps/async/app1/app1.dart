void main() {
  Future.delayed(Duration(seconds: 1), () => print(11));
  Future.delayed(Duration.zero, () => print(6));
  Future(() => print(7)).then((_) => print(8));
  Future.sync(() => print(1));
  Future.microtask(() => print(4));
  print(2);
  Future.microtask(() => print(5));
  Future.sync(() => print(3));
  Future(() => print(9));
  Future.delayed(Duration.zero, () => print(10));
  Future.delayed(Duration(seconds: 1), () => print(12));
}