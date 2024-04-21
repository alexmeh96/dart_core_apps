import 'dart:mirrors';

class Ioc {
  bool get isInit => false;
  List<ClassMirror> classList = [];

  List<ClassMirror> findClassesFromPackages(List<String> packagesPrefix) {
    var mirrorSystem = currentMirrorSystem();

    for (var packagePrefix in packagesPrefix) {
      mirrorSystem.libraries.forEach((uri, libraryMirror) {
        // Проверка, что URI библиотеки начинается с заданного префикса
        if (uri.toString().startsWith(packagePrefix)) {
          // Получение списка классов в библиотеке
          var iterable = libraryMirror.declarations.values.whereType<ClassMirror>();
          classList.addAll(iterable);
        }
      });
    }

    return classList;
  }
}
