import 'package:flutter/material.dart';

class ObjectWatcher<T> with ChangeNotifier {
  ObjectWatcher(this._value);

  T _value;
  T get value => _value;
  set value(T v) {
    _value = v;
    notifyListeners();
  }

  void refresh() => notifyListeners();

  @override
  String toString() => value.toString();
}

/// int
class IntWatcher extends ObjectWatcher<int> {
  IntWatcher(super.value);

  void operator +(int other) {
    value = value + other;
  }

  void operator *(int other) {
    value = value * other;
  }
}

/// double
class DoubleWatcher extends ObjectWatcher<double> {
  DoubleWatcher(super.value);

  void operator +(double other) {
    value = value + other;
  }

  void operator *(double other) {
    value = value * other;
  }
}

extension ObjectWatcherExtension<T> on T {
  ObjectWatcher<T> get toWatch => ObjectWatcher<T>(this);
}

extension IntWatcherExtension on int {
  IntWatcher get toWatch => IntWatcher(this);
}

extension DoubleWatcherExtension on double {
  DoubleWatcher get toWatch => DoubleWatcher(this);
}

/// builder
class WatcherBuilder<T> extends StatefulWidget {
  const WatcherBuilder(
      {super.key, required this.watcher, required this.builder});

  final ObjectWatcher<T> watcher;

  final Widget Function(BuildContext context, T value) builder;

  @override
  State<WatcherBuilder<T>> createState() => _WatcherBuilderState<T>();
}

class _WatcherBuilderState<T> extends State<WatcherBuilder<T>> {
  void onChanged() {
    setState(() {});
  }

  @override
  void initState() {
    widget.watcher.addListener(onChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WatcherBuilder<T> oldWidget) {
    if (oldWidget.hashCode != this.widget.hashCode ||
        oldWidget.watcher != this.widget.watcher) {
      oldWidget.watcher.removeListener(onChanged);
      widget.watcher.addListener(onChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.watcher.removeListener(onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.watcher.value);
  }
}
