void main() async {
  print(await getUserName());
  print(await getCity());
}

Future<String> getUserName() async => 'alex meh';

Future<String> getAddress() => Future.value('123');

Future<String> getPhoneNumber() =>
    Future.delayed(const Duration(seconds: 1), () => '111-111-1111');

Future<String> getCity() async {
  await Future.delayed(Duration(seconds: 1));
  return "Belarus";
}
