import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//채팅을 구현하는 페이지이다.

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserId;
  //받는 사람의 이메일, id를 받는 변수

  const ChatPage({
    super.key,
    required this.receiveruserEmail,
    required this.receiverUserId,
  });
  //ChatPage는 email과, uid를 전달받고 이 정보를 통해 사용이 가능하다.
  //HomePage로 부터 값을 받는다.

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
    if (_messageController.text.isNotEmpty) {
      //메시지에 무언가 적혀힜다면,
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
      //firebase의 chatService를 사용해 userId, 메시지 내용을 보낸다.

      _messageController.clear();
      //보낸 메시지 내용 지우기
    }
  }

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
            //_buildMessageList를 이용하여 메시지리스트를 만듬
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
      //ChatService의 getMessage를 사용한다. receiverUserId, 현재 사용자 uid를 넘긴다.
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        } //에러가 있으면 에러를 Text로 출력하라.

        if (snapshot.connectionState == ConnectionState.waiting) {
          const Text('Loading...');
        } // 값을 불러오는 중에는 Text를 출력하라.

        if (snapshot.data == null) {
          return const Text('No data available'); // 또는 다른 처리 방법을 선택할 수 있습니다.
        } //만약 불러올 값이 없다면, Text를 반환하다.

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          ),
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
    //키값을 통해 타입과 관계없이 값을 가져오기 위해 위와 같이 맵핑한다.

    var aligment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    //저장된 메시지는 model에 정의된 형태로 저장되어 있다.
    // 그 저장된 값 중 senderId가 현재 사용자 정보와 일치하면 오른쪽으로 정렬, 아니면
    // 왼쪽으로 정렬하는 변수.

    var idAligment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    //senderId는 왼쪽으로, 현재 사용자는 오른쪽으로 정렬하는 변수

    var messageColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? const Color(0xFF2196F3)
        : const Color(0xFF4CAF50);
    //senderId는 파란색으로 현재사용자가 보내는 메시지는 녹색으로 바꾸는 변수

    return Container(
      alignment: aligment,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          ChatBubble(
            userId: data['senderEmail'],
            message: data['message'],
            messageColor: messageColor,
            alignment: aligment,
            idAligment: idAligment,
          ),
          //Firesotre에 저장된 message를 불러옴
          //ChatBubble 스타일 적용
        ],
      ),
    );
  }

  //메시지 입력창
  Widget _buildMessageInput() {
    //메시지 입력창을 구현
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: '메시지를 입력하세요',
              obscureText: false,
              //민감한 정보 가리지 않음
            ),
          ),

          //sendmessage
          IconButton(
            onPressed: sendMessage,
            //snedMessage 함수를 통해 기능을 구현
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
