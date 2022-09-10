import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatSession with ChangeNotifier {
  List<types.Message> _messages = [];

  List<types.Message> get messages => _messages;

  void _addMessage(types.Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  // ignore: prefer_final_fields
  Socket _socket = io(
      'https://gainsborodroopyrobodoc.harrykanani.repl.co', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  bool _isConnected = false;

  bool get isConnected => _isConnected;
  Socket get socket => _socket;
  var _user = types.User(id: 'bf8d6f3ac');

  types.User get user => _user;

  void connectToServer() async {
    try {
      socket.connect();
      print(socket.id);

      while (socket.connected == false) {
        await Future.delayed(Duration(seconds: 2));
      }
      notifyListeners();
      _user = types.User(id: socket.id!, firstName: 'user ${socket.id!}');
      // socket.onopen((_) => notifyListeners());
      await Future.delayed(Duration(seconds: 5));
      // socket.onconnect((data) {
      //   print('connected');
      //   // notifyListeners();
      // });

      socket.onDisconnect((data) => print('disconnected'));

      socket.on('connect message', (_) {
        print('connect: ${socket.id}');
      });

      socket.on('chat message', (data) {
        print(socket.id);
        print(data);
        Map<String, dynamic> msgData = jsonDecode(data) as Map<String, dynamic>;
        if (msgData.containsKey('client') &&
            msgData.containsKey('operatorAccount') &&
            msgData.containsKey('message')) {
          var userMsg = types.User(
            id: msgData['client']!,
            firstName: 'User ${msgData['client']!}',
          );
          if (userMsg.id != _user.id) {
            var msg = types.TextMessage(
                author: userMsg,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: DateTime.now().toString(),
                text: msgData['message']!);
            print(_messages);
            _addMessage(msg);
          }
        }
      });

      socket.onerror((err) {
        _isConnected = false;
        // notifyListeners();
        print(err.toString());
        return 'error';
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void sendMsg(String msg) {
    socket.emit('chat message', msg.toString());
    var message = types.TextMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: msg);
    _addMessage(message);
  }
}
