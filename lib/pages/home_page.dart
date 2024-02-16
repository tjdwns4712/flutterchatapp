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
  User? currentUser = FirebaseAuth.instance.currentUser;

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
        title: const Text(
          '친구 목록',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _buildUserList(),
      ),
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

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // _buildUserListItem을 호출하여 각 사용자를 위한 위젯을 만듭니다.
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildUserListItem(
                  snapshot.data!.docs[index],
                ),
              ),
            );
          },
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
      return ListTile(
        title: Text(
          data['email'],
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserEmail: data['email'],
                receiverUserId: data['uid'],
              ),
            ),
          );
        },
        tileColor: Colors.white, // 혹시 배경색을 변경하고 싶다면 여기에 추가
      );
    } else {
      // return a container with blue background for the current user
      return Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.all(16),
        child: Text(
          data['email'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
