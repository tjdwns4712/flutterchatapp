import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    );
  }
}
