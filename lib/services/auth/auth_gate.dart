import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 이 페이지는 사용자의 상태에 따라 어떤 페이지로 연결시킬지 결정하는 역할을 한다.

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //비동기 처리를 하고 화면을 업데이트 한다.

        stream: FirebaseAuth.instance.authStateChanges(),
        //사용자의 인증상태 변화를 감지한다. 로그인할 떄, 로그아웃 할 때를 감지한다.

        builder: (context, snapshot) {
          //현재 스트림 상태를 기반으로 UI를 동적으로 생성(로그인, 로그아웃)

          if (snapshot.hasData) {
            //snapshot를 통해 현재 현재 인증상태를 확인 true면(로그인 상태면)
            return const HomePage();
            //HomgPage로 연결한다
          } else {
            return const LoginOrRegister();
            //아니면 LoginOrRegister로 이동한다.
          }
        },
      ),
    );
  }
}
