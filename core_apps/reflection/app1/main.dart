import 'dart:mirrors';

class Author {
  final String name;
  final int year;

  const Author(this.name, this.year);
}

@Author('John Doe', 2022)
class Book {
  final String title;
  final int page;

  Book(this.title, this.page);

  void info() {
    print('title: $title; page: $page');
  }
}

void main() {
  var book = Book('Harry Potter', 350);

  // Получаем зеркало для объекта book
  var bookMirror = reflect(book);

  // Получаем имя класса
  print(bookMirror.type.simpleName); // Person

  // Получаем список полей и их значений
  var fields = bookMirror.type.instanceMembers.values.whereType<VariableMirror>();
  fields.forEach((field) {
    var value = bookMirror.getField(field.simpleName).reflectee;
    print('${field.simpleName}: $value');
  });

  // Вызываем метод info динамически
  var greetMethod = bookMirror.type.instanceMembers.values.firstWhere((m) => m.simpleName == #info);
  bookMirror.invoke(greetMethod.simpleName, []);

  // Получение зеркала класса Book
  var classMirror = reflectClass(Book);
  // Получение аннотации Author
  var authorAnnotation = classMirror.metadata.firstWhere((m) => m.reflectee is Author).reflectee;

  // Вывод информации из аннотации
  print('Author: ${authorAnnotation.name}, Year: ${authorAnnotation.year}');
}
