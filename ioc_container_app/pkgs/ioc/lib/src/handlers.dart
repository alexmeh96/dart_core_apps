import 'dart:mirrors';

enum MethodType {
  TCP_HANDLER,
  WEBSOCKET_HANDLER,
  HTTP_HANDLER;
}

class MethodOption {
  InstanceMirror instanceMirror;
  Symbol name;
  MethodType type;

  MethodOption(this.instanceMirror, this.name, this.type);

  void invoke(params) {
    instanceMirror.invoke(name, params);
  }

}
