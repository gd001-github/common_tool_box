import 'dart:async';
import 'dart:isolate';

import 'package:common_tool_box/extensions/template_extension.dart';
import 'package:flutter/material.dart';

class PortWrap {
  ReceivePort? _receivePort;
  ReceivePort get receivePort {
    _receivePort ??= ReceivePort().let((it) {
      _streamSubscription = it.asBroadcastStream().listen((event) {
        listen?.call(event);
      });
    });
    return _receivePort!;
  }

  StreamSubscription? _streamSubscription;

  void Function(Object data)? listen;
}

class Isolation {
  Isolation() {
    init();
  }

  final _msgPortWrap = PortWrap();
  final _exitPortWrap = PortWrap();
  final _errorPortWrap = PortWrap();

  SendPort? newIsolateSendPort;

  Isolate? _newIsolate;

  Future<void> init() async {
    _msgPortWrap.listen = _onNewIsolateMessage;
    _newIsolate = await Isolate.spawn<SendPort>(
        _entryPoint, _msgPortWrap.receivePort.sendPort,
        onExit: _exitPortWrap.receivePort.sendPort,
        onError: _errorPortWrap.receivePort.sendPort,
        debugName: 'newIsolate');
  }

  static void _entryPoint(SendPort formerSendPort) {
    NewIsolationSpace(formerSendPort);
  }

  void _onNewIsolateMessage(Object msg) {
    debugPrint('来自new对象的信息:${msg.toString()}');
    if (msg is SendPort) {
      newIsolateSendPort = msg;
    }
  }

  void fireMsg(Object msg) {
    newIsolateSendPort?.send(msg);
  }

  void closeIsolate() {
    _newIsolate?.kill();
  }
}

class NewIsolationSpace {
  NewIsolationSpace(this.builderSendPort) {
    _init();
  }

  final SendPort builderSendPort;

  final _msgPortWrap = PortWrap();

  void _init() {
    _msgPortWrap.listen = _onBuilderMessage;
    builderSendPort.send(_msgPortWrap.receivePort.sendPort);
  }

  void _onBuilderMessage(Object msg) {
    debugPrint('来自建造者信息:${msg.toString()}');
    if (msg is Map) {
      if (msg['fun'] is Function()) {
        final ret = msg['fun'].call();
        builderSendPort.send(ret);
      } else if (msg['fun'] is Function(Object)) {
        final ret = msg['fun'].call(msg['param']);
        builderSendPort.send(ret);
      }
    }
  }
}
