import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmali;
  final String receiverUserId;

  const ChatPage({
    super.key,
    required this.receiveruserEmali,
    required this.receiverUserId,
  });
  //ChatPage는 email과, uid를 전달받는다.

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveruserEmali),
      ),
    );
  }
}
