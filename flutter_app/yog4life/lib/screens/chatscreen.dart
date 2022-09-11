import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChatSession>(context, listen: false).connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    var chatSession = Provider.of<ChatSession>(context);

    void _sendMessageHandelr(types.PartialText message) {
      chatSession.sendMsg(message.text);
    }

    var chat_theme = DefaultChatTheme(
      sentMessageBodyTextStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
      ),
      inputTextStyle: Theme.of(context).textTheme.bodyText1!,
      inputTextColor: Colors.black,
      inputBackgroundColor: Colors.amber.shade50,
      primaryColor: Colors.amber.shade200,
      secondaryColor: Colors.amber.shade100,
    );

    return chatSession.socket.connected == false
        ? Scaffold(
            appBar: AppBar(title: const Text('connecting')),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/yoga-loading.json'),
                  const SizedBox(height: 20),
                  const Text('Connecting to the chat room'),
                ],
              ),
            ),
          )
        : Scaffold(
            // appBar: AppBar(title: const Text('connected')),
            body: Chat(
              messages: chatSession.messages,
              theme: chat_theme,
              onSendPressed: _sendMessageHandelr,
              user: chatSession.user,
              groupMessagesThreshold: 6000,
              showUserNames: true,
              onMessageDoubleTap: chatSession.msgLongPressHandler,
              onMessageTap: chatSession.msgLongPressHandler,
            ),
          );
  }
}
