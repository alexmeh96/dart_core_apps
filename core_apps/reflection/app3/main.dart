import 'dart:mirrors';

class User {
  String name;
  int age;

  User(this.name, this.age);

  void greet() {
    print('Hello, my name is $name and I am $age years old.');
  }
}


class UserProxy {
  final User _user;
  final ObjectMirror _mirror;

  UserProxy(this._user) : _mirror = reflect(_user);

  dynamic delegate(Invocation invocation) {
    if (invocation.isGetter) {
      return _mirror.getField(invocation.memberName).reflectee;
    } else if (invocation.isSetter) {
      _mirror.setField(invocation.memberName, invocation.positionalArguments[0]);
      return null;
    } else {
      return _mirror.invoke(
        invocation.memberName,
        invocation.positionalArguments,
        invocation.namedArguments,
      ).reflectee;
    }
  }
}


void main() {
  var invocation = Invocation(methodName, positionalArguments, namedArguments);

}
