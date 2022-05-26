export 'package:common_tool_box/extensions/template_extension.dart';

extension TemplateExtension<T> on T {
  T let(Function(T it) fun) {
    fun(this);
    return this;
  }

  R also<R>(R Function(T it) fun) => fun(this);

  void go(Function(T it) fun) => fun(this);
}
