import 'package:chatapp/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  //ChangeNotifier는 상태변화를 감지하고, 리스너에게 전해준다.

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Firebase의 인증, 데이터베이스 인스턴스 정의

  //메시지 보내기
  Future<void> sendMessage(String receiverId, String message) async {
    //get current info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //Firebase의 인증에서 사용자 아이디를 가져오고, 사용자 인증으로 부터 사용자 email을 가져오며,
    //timestamp는 현재시간을 저장한다.

    //새로운 메시지 생성하기
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );
    //model.dart에 만들어준 형식을 사용하여 각종 정보를 저장한다.
    //receiverId, message는 입력받는다.

    //currend user id, receiver id를 조합해 roomid만들기
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRroomId = ids.join("_");
    //두 가지 id를 조합해 하나로 묶으면서 chatroom id를 만든다.

    //새로운 메시지 데이터베이스에 넣기
    await _firestore
        .collection('chat_rooms')
        .doc(chatRroomId)
        .collection('messages')
        .add(newMessage.toMap());
  } // firestore의 chat_rooms 컬랙션의 chatRoomId통해 문서를 참조하면서 message라는 하위 컬랙션을 참조하면서
  // newMessage 객체를 toMap형태로 집어넣어라.

  //메시지 받아오기
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    //메시지 보내기에서 만든 chatroomid를 통해 값을 받아오기 위해 user id, otheruser id를
    //조합해 chatRoomId를 만듬.

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
    //chat_rooms 컬랫션에 chatRoomId를 통해 문서에 접근하여 하위 컬랙션인 messages에
    //timestamp로 오름차순 정렬하여 값을 가져옴.
  }
}
