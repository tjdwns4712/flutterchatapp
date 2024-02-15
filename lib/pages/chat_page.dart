import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserId;

  const ChatPage({
    super.key,
    required this.receiveruserEmail,
    required this.receiverUserId,
  });
  //ChatPage는 email과, uid를 전달받고 이 정보를 통해 사용이 가능하다.

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //메시지 입력을 위한 TextEditingController, 만들어둔 ChatService,
  //인증을 위한 FirebaseAuth를 사용하기 위한 변수 설정

  void sendMessage() async {
    //only send a message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);

      //clear the text after sending message
      _messageController.clear();
    }
  }
  //메시지를 보내기 위한 함수. _messageController에 어떤 값이 입력되었으면,
  //ChatService에 정의된 sendMessage를 사용해 Firebase에 값을 저장한다.

  @override
  Widget build(BuildContext context) {
    //ChatPage 화면구현부
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveruserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),
          //user input
          _buildMessageInput(),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      //StreamBuilder를 통해 스트림 변화를 감지하고, 변화에 대한 화면 업데이트를 진행한다.
      //snapshot는 현재 스트림 상태를 나타낸다.

      stream: _chatService.getMessages(
          widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        // ChatService의 getMessage에 값을 넣어 데이터베이스로 부터 값을 받아온다.

        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        //에러가 있으면 에러를 Text로 출력하라.

        if (snapshot.connectionState == ConnectionState.waiting) {
          const Text('Loading...');
        }
        // 값을 불러오는 중에는 Text를 출력하라.

        if (snapshot.data == null) {
          return const Text('No data available'); // 또는 다른 처리 방법을 선택할 수 있습니다.
        }
        //만약 불러올 값이 없다면, Text를 반환하다.

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
        //위에 해당하지 않는다면, ListView형태로 _buildMessageItem을 출력하라.
        //getMessage를 통해 현재시간으로 정렬된 메시지를 받아온다.
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //Firestore의 DocumentSnapshotsms Map<String, dynamic>형태로 저장되기 때문에
    // 명시적인 형변환을 한다.

    // align the messages to the right if the sender is user, other user to thr left
    var aligment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    //저장된 메시지는 model에 정의된 형태로 저장되어 있다.
    // 그 저장된 값 중 senderId가 현재 사용자 정보와 일치하면 오른쪽으로 정렬, 아니면
    // 왼쪽으로 정렬하는 변수.

    return Container(
      alignment: aligment,
      //위 aligment에서 정의된 방식으로 정렬
      child: Column(
        children: [
          Text(data['senderEmail']),
          //Firesotre에 저장된 senderEmail을 불러옴
          const SizedBox(
            height: 5,
          ),
          ChatBubble(message: data['message']),
          //Firesotre에 저장된 message를 불러옴
          //ChatBubble 스타일 적용
        ],
      ),
    );
  }

  //메시지 입력창
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
              //민감한 정보 가리지 않음
            ),
          ),

          //sendmessage
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
