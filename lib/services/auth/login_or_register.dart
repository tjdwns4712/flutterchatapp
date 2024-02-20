import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:flutter/material.dart';

//이 페이지는 LoginPage과 RegisterPage 둘 중 어떤 페이졸 보낼지 결정하는 페이지다.

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  //bool타입의 showLoginPage값을 반전하는 함수

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
    //showLoginPage의 값에 따라 LoginPage와 RegisterPage으로 이동한다.
    //onTap은 위젯 내 터치 이벤트가 발생했을 때 발동된다.
  }
}
