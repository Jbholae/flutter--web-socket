import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

import '../../config.dart';
import '../injector.dart';

class MessageNotifierProvider with ChangeNotifier {
  final IOWebSocketChannel _channel = IOWebSocketChannel.connect(
    "${Config.socketUrl}/users/notify",
    headers: {
      HttpHeaders.authorizationHeader:
      'Bearer ${sharedPreferences.getString('token')}',
    },
  );
  late final BehaviorSubject<dynamic> _notifyStream = BehaviorSubject()..addStream(_channel.stream);

  MessageNotifierProvider() : super() {
    _notifyStream.listen((value) {

    });
  }

  BehaviorSubject<dynamic> get notifyStream => _notifyStream;
}
