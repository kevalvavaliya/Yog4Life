import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher.dart';

class ChatSession with ChangeNotifier {
  List<types.Message> _messages = [];

  List<types.Message> get messages => _messages;

  void _addMessage(types.Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  // ignore: prefer_final_fields
  Socket _socket = io(
      'https://gainsborodroopyrobodoc.ghelanibhavin.repl.co', <String, dynamic>{
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

      socket.onDisconnect((data) => notifyListeners());

      socket.on('connect message', (_) {
        print('connect: ${socket.id}');
      });

      socket.on('chat message', (data) {
        print(socket.id);
        print(data);
        SocketMsg msgData = SocketMsg.fromJson(data);
        print(msgData.txid);
        // Map<String, dynamic> msgData = socketMsg.fromJson(data);
        // jsonDecode(data).cast(Map<String, dynamic>);
        if (msgData.client != null &&
            msgData.operatorAccount != null &&
            msgData.message != null &&
            msgData.txid != null) {
          print(msgData.txid.toString());
          var userMsg = types.User(
            id: msgData.client!,
            firstName: 'User ${msgData.client!}',
          );
          if (userMsg.id != _user.id) {
            var msg = types.TextMessage(
                author: userMsg,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: DateTime.now().toString(),
                text: msgData.message!,
                metadata: {
                  'txUrl':
                      'https://testnet.hederaexplorer.io/search-details/transaction/${msgData.operatorAccount}-${msgData.txid}'
                });
            print(_messages);
            _addMessage(msg);
          } else {
            var msgIndex = _messages
                .indexWhere((element) => element.author.id == userMsg.id);

            _messages[msgIndex].metadata!.addAll({
              'txUrl':
                  'https://testnet.hederaexplorer.io/search-details/transaction/${msgData.operatorAccount}-${msgData.txid}'
            });
            print(_messages[msgIndex].metadata.toString());
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
      text: msg,
      metadata: {},
    );
    _addMessage(message);
  }

  void msgLongPressHandler(BuildContext ctx, types.Message msg) {
    print('msg tap');
    if (msg.metadata != null) {
      if (msg.metadata!.containsKey('txUrl')) {
        print(msg.metadata!['txUrl']);
        showDialog(
            context: ctx,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: const Text('View transaction in Hedera Explorer'),
                content: const Text(
                    'You will be redirtected to the Hedera Explorer to view the transaction'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        // html.window
                        //     .open(msg.metadata!['txUrl'], 'Hedera Explorer');
                        launchUrl(Uri.parse(msg.metadata!['txUrl']));
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('View')),
                ],
              );
            });
      }
    }
  }
}

class SocketMsg {
  String? operatorAccount;
  String? client;
  String? message;
  String? txid;

  SocketMsg({this.operatorAccount, this.client, this.message, this.txid});

  SocketMsg.fromJson(Map<String, dynamic> json) {
    operatorAccount = json['operatorAccount'];
    client = json['client'];
    message = json['message'];
    txid = json['txid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operatorAccount'] = this.operatorAccount;
    data['client'] = this.client;
    data['message'] = this.message;
    data['txid'] = this.txid;
    return data;
  }
}
