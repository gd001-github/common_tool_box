class FutureTask {
  late final Function _backCall;
  final Duration duration;
  bool _isClose = false;

  FutureTask(this.duration, Function backCall) {
    _backCall = backCall;
  }

  void start() {
    Future.delayed(duration, () {
      if (!_isClose) {
        _backCall.call();
      }
    });
  }

  void close() => _isClose = true;
}
