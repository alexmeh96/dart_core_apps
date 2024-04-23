import 'dart:mirrors';

import 'package:ioc/src/annotations.dart';
import 'package:ioc/src/handlers.dart';

class Ioc {
  bool get isInit => false;
  List<ClassMirror> classList = [];
  Map<String, Object> container = {};
  List<MethodOption> methods = [];

  void init(List<String> packagesPrefix) {
    findClassesFromPackages(packagesPrefix);
    findComponentClasses();
    resolveDependencies();
    resolveMethods();
  }

  void findClassesFromPackages(List<String> packagesPrefix) {
    var mirrorSystem = currentMirrorSystem();

    for (var packagePrefix in packagesPrefix) {
      mirrorSystem.libraries.forEach((uri, libraryMirror) {
        // Проверка, что URI библиотеки начинается с заданного префикса
        if (uri.toString().startsWith(packagePrefix)) {
          // Получение списка классов в библиотеке
          var iterable =
              libraryMirror.declarations.values.whereType<ClassMirror>();
          classList.addAll(iterable);
        }
      });
    }
  }

  void findComponentClasses() {
    for (var classMirror in classList) {
      for (var instanceMirror in classMirror.metadata) {
        if (instanceMirror.reflectee is Component) {
          container[classMirror.reflectedType.toString()] =
              classMirror.newInstance(Symbol.empty, []).reflectee;
          break;
        }
      }
    }
  }

  void resolveDependencies() {
    container.forEach((id, instance) {
      var classMirror = reflect(instance);
      var fields = classMirror.type.declarations.values.whereType<VariableMirror>();

      fields.forEach((field) {
        for (var metadata in field.metadata) {
          if (metadata.reflectee is Inject) {
            var obj = container[field.type.reflectedType.toString()];
            if (obj != null) {
              classMirror.setField(field.simpleName, obj);
            } else {
              // todo: выбросить исключение, что внедряемый объект не найден
            }
            break;
          }
        }
      });
    });
  }

  void resolveMethods() {
    container.forEach((id, instance) {
      var instanceMirror = reflect(instance);
      var methodMirrors = instanceMirror.type.instanceMembers.values.toList();

      for (var methodMirror in methodMirrors) {
        for (var instance in methodMirror.metadata) {
          if (instance.reflectee is TcpHandler) {
            methods.add(MethodOption(instanceMirror, methodMirror.simpleName, MethodType.TCP_HANDLER));
            break;
          }
          if (instance.reflectee is HttpHandler) {
            methods.add(MethodOption(instanceMirror, methodMirror.simpleName, MethodType.HTTP_HANDLER));
            break;
          }
        }
      }
    });
  }


  //---------------------------------------------------------------------------------------------------------

  List<MethodOption> findTcpHandlers() {
    List<MethodOption> methodsOptions = [];
    for (var classMirror in classList) {
      for (var instanceMirror in classMirror.metadata) {
        if (instanceMirror.reflectee is Component) {
          var methodMirrors = classMirror.instanceMembers.values.toList();

          for (var methodMirror in methodMirrors) {
            for (var instance in methodMirror.metadata) {
              if (instance.reflectee is TcpHandler) {
                // todo:
                break;
              }
            }
          }
        }
      }
    }

    return methodsOptions;
  }
}
