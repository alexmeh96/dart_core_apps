void main() async {
  // равносильные записи
  final length1 = await calculateLength(await getFullName());
  print(length1);

  // равносильные записи
  final length2 = await getFullName().then((value) => calculateLength(value));
  print(length2);
}

Future<String> getFullName() =>
    Future.delayed(Duration(seconds: 1), () {
      print('getFullName');
      return 'alex meh';
    });

Future<int> calculateLength(String value) =>
    Future.delayed(Duration(seconds: 1), () {
      print('calculateLength');
      return value.length;
    });
