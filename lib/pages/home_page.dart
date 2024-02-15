import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign user out
  void signOut() {
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    //Provider패키지를 사용하여 AuthService(auth_service의 클래스)의 인스턴스를 찾음.
    //listen: false 변화를 감지하지 않는다는 의미.

    authService.signOut();
    //인스턴스를 중 signOut를 실행함.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  //build a list of user for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      //Firestore의 데이터를 스트리밍하여 화면에 업데이트하는 위젯 QuerySnapshot은 쿼리 결과 스냅샷

      stream: FirebaseFirestore.instance.collection('uesrs').snapshots(),
      //Firestore의 uesrs콜랙션의 데이터를 실시간으로 스트리밍하겠다는 의미

      builder: (context, snapshot) {
        //스트림 상황에 따라 UI를 빌드하는 콜백함수 snapshot는 현재 데이터 및 상태를 나타냄

        if (snapshot.hasError) {
          //에러가 있는 경우
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          //데이터를 불러오는(snapshot.connectionState) 데 로딩이 있을 경우
          return const Text('Loading...');
        }

        return ListView(
          //특이 사항이 없다면
          children: snapshot.data!.docs
              //스트리밍으로 부터 받은(snapshot) 데이터(data)의 각 문서(docs) 에 대해
              .map<Widget>((doc) => _buildUserListItem(doc))
              // _buildUserListItem을 호출하여 각 사용자를 위한 위젯 목록형태로 만듬
              .toList(),
        );
      },
    );
  }

//build individual user list item

  Widget _buildUserListItem(DocumentSnapshot document) {
    //각 사용자에 대한 DocumentSnapshot을 매개변수로 받음

    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //document로 부터 받은 데이터를 Map형태로 저장한다. !는 nullSafty이다.

    //display all user except current user
    if (_auth.currentUser!.email != data['email']) {
      //FirebaseAuth 의 인스턴스인 _auth로 부터 현재 사용자 정보를 받아 FirebaseFireStore의
      //email과 비교해 같지 않는 경우(사용자가 아닌 다른 사람의 경우)

      return ListTile(
        title: Text(data['email']),
        // 각 사용자의 email을 각 리스트 텍스츠로 표시
        onTap: () {
          //pass the clicked user's UID to the chat page
          //해당 리스트 타일을 누르면
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                //ChatPage로 이동한다
                //ChatP age는 email, uid를 필수로 입력해야하므로, 상용자의 email, uid를 전달한다.
                receiveruserEmail: data['email'],
                receiverUserId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      //return empth container
      return Container();
    }
  }
}
