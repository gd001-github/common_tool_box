// typedef FunCallback = bool Function();

class RetryUtils {
  RetryUtils(this.retryCount, this.interval, this.callBack);

  ///重试次数
  final int retryCount;

  ///每次间隔
  final Duration interval;

  ///回调函数
  final bool Function(int tryCount) callBack;

  ///计算次数
  int _count = 0;

  Future<void> run() async {
    _count++;
    if (_count <= retryCount) {
      var ret = false;
      await Future.delayed(interval, () {
        ret = callBack.call(_count);
      });
      if (!ret) {
        await run();
      }
    }
  }
}
