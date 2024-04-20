import 'package:reflectable/reflectable.dart';

import 'main.reflectable.dart';

class MyAnnotation {
  const MyAnnotation();
}

class MyReflectable extends Reflectable {
  const MyReflectable() : super(invokingCapability, declarationsCapability, metadataCapability);
}

const myAnnotation1 = MyReflectable();
const myAnnotation2 = MyReflectable();

@myAnnotation1
class MyClass1 {
}

@MyAnnotation()
@myAnnotation1
class MyClass2 {
}

@myAnnotation2
class MyClass3 {
}

@MyAnnotation()
class MyClass4 {
}

Iterable<ClassMirror> getAnnotatedClasses(Reflectable reflector) {
  var annotatedClasses = <ClassMirror>[];

  for (var classMirror in reflector.annotatedClasses) {
    if (classMirror.metadata.any((m) => m is MyAnnotation)) {
      annotatedClasses.add(classMirror);
    }
  }

  return annotatedClasses;
}

void main() {
  initializeReflectable();

  var classesWithAnnotation = getAnnotatedClasses(myAnnotation1);

  for (var classMirror in classesWithAnnotation) {
    print('Found class with annotation: ${classMirror.simpleName}');
  }
}
