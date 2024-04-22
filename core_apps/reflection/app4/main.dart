import 'dart:mirrors';

void myMethod(String message) {
  print("Method called with message: $message");
}

void main() {
  // Создание зеркала функции myMethod
  var myMethodMirror = reflect(myMethod);

  // Вызов метода с использованием зеркала и создание Invocation
  var invocation = Invocation.method(
      #myMethod,  // Symbol для имени метода
      ['Hello from invocation!']  // Позиционные аргументы
  );

  // Перехват и обработка Invocation
  var result = myMethodMirror.invoke(invocation.memberName, invocation.positionalArguments);
  print(result.reflectee);  // Вывод результата вызова
}
