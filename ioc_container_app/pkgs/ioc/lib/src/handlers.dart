import 'dart:mirrors';

class MethodOption {
  InstanceMirror instanceMirror;
  Symbol name;

  MethodOption(this.instanceMirror, this.name);

  void invoke(params) {
    instanceMirror.invoke(name, params);
  }

}
