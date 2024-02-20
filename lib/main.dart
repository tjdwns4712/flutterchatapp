import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//이 파일은 메인페이지 이다, 시작시 각종 초기화, 초기 페이지로 이동을 담당한다.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //앱이 실행될 때 초기화되도록 함.

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //firebase 초기화

  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const ChatApp(),
  ));
}
//상태관리와 의존성을 주입하는 부분
//AuthService의 인스턴스를 생성하고 이를 provider 패키지를 통해 위젯
//전체에서 사용할 수 있도록 하는것.

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      //AuthGate로 이동한다.
    );
  }
}
