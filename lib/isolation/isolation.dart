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
    } else if (msg is Map) {
      if (msg.containsKey('error')) {
        final message = msg['error'];
        debugPrint(message);
      }
    }
  }

  Future<dynamic> getResult(
      Future<dynamic> Function(Object) callBack, Object params) {
    final completer = Completer<dynamic>();
    final portWrap = PortWrap();
    portWrap.listen = completer.complete;
    Future<dynamic> fun() {
      return callBack.call(params);
    }

    try {
      newIsolateSendPort?.send({
        'fun': fun,
        'sendPort': portWrap.receivePort.sendPort,
      });
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
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
    try {
      debugPrint('来自建造者信息:${msg.toString()}');
      (msg as Map).go((map) async {
        final sendPort = map['sendPort'] as SendPort;
        final fun = map['fun'] as Future<dynamic> Function();
        final ret = await fun.call();
        sendPort.send(ret);
      });
    } catch (e) {
      builderSendPort.send({'error': e.toString()});
    }
  }
}
