import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//HomePage는 로그인 한 후 페이지를 나타낸다. 유저리스트를 나타낸다.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //FirebaseAuth를 불러오는 인스턴스

  User? currentUser = FirebaseAuth.instance.currentUser;
  //currentUser는 firebase로 부터 사용자 정보를 받아와 저장한다.

  //sign user out
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    //Provider패키지를 사용하여 AuthService(auth_service의 클래스)의 인스턴스를 찾음.
    //listen: false 변화를 감지하지 않는다는 의미.

    authService.signOut();
    //AuthService(auth_service의 클래스) 인스턴스에 signOut를 실행함으로서 로그아웃을 진행함.
  }

  //화면 빌드
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

  //현재 로그인한 유저들의 리스트를 만듬
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      //Firestore의 데이터를 스트리밍(읽음)하여 화면에 업데이트하는 위젯 QuerySnapshot은 쿼리 결과 스냅샷

      stream: FirebaseFirestore.instance.collection('uesrs').snapshots(),
      //Firestore의 uesrs콜랙션의 데이터를 실시간으로 스트리밍(읽음)하겠다는 의미

      builder: (context, snapshot) {
        //스트림 상황에 따라 UI를 빌드하는 콜백함수 snapshot는 현재 데이터 및 상태를 나타냄

        if (snapshot.hasError) {
          //에러가 있는 경우
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          //데이터를 불러오는(snapshot.connectionState) 데 로딩이 있을 경우 텍스트 출력
          return const Text('Loading...');
        }
        //위에 해당하지 않는 정상적인 경우
        return ListView.builder(
          //ListView를 이용해 리스트를 만든다

          itemCount: snapshot.data!.docs.length,
          // item개수는 읽어논 데이터인 snapshot의 개수

          itemBuilder: (context, index) {
            // _buildUserListItem을 호출하여 각 사용자를 위한 위젯을 만듭니다.
            // context는 트리위 위치르르, index는 list에 생성되는 값의 순서이다 첫 번째면 0, 두 번째면 1 이런식
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
                  //여기서 만든 틀 안에 넣을 값을 _buildUserListItem에서 만들어 가져온다
                  //_buildUserListItem에 Firestore의 users의 정보를 읽어와 넘긴다
                  snapshot.data!.docs[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //개별 사용자 리스트를 만듬
  Widget _buildUserListItem(DocumentSnapshot document) {
    //각 사용자에 대한 DocumentSnapshot을 매개변수로 받음
    //위젯으로 만들어 반환해 ListView안에 넣을 수 있도록 한다.

    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //document로 부터 받은 데이터를 Map형태로 저장한다. !는 nullSafty이다.
    //키를 String, 값을 dynamic로 만들어 여러 타입으로 활용하기 좋게 데이터를 가공하는 것이다.
    //예를 들어 email을 가져올 때 String 타입인 email을 키로 넣으면 해당하는 email타입의 값을 유연하게 가져온다.

    //display all user except current user
    if (_auth.currentUser!.email != data['email']) {
      //현재 사용자 정보와 가져온 정보가 다른 경우(현재 로그인한 사용자가 아닌 다른 사용자)
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
                //이 유저를 누르면(터치인식) ChatPage로 이동하며 email, uid값을 넘긴다.
              ),
            ),
          );
        },
        tileColor: Colors.white,
      );
    } else {
      // 아닌 경우(현재 로그인한 사용자의 경우)
      return Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.all(16),
        child: Text(
          data['email'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            //이 스타일로 한다.
          ),
        ),
      );
    }
  }
}
