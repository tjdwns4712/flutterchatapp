import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginpageState();
}

class _LoginpageState extends State<LoginPage> {
  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user
  void signIn() async {
    //get auth service

    final authService = Provider.of<AuthService>(context, listen: false);
    // Provider패킬지를 이용하여 AuthService서비스를 가져온다.
    //listen = false로 값이 변해도 위젯을 다시 빌드하지 않습니다.

    try {
      await authService.signInwithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
      //emailController, passwordController를 통해 입력받은 값을
      //signInwithEmailandPassword로 보내어 firebase로 부터 사용자인지 확인
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            // 로그인 실패시 에러 메시지를 SnackBar을 통해 띄운다.
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[700],
      body: SafeArea(
        // os따라 필요한 패딩값을 적절히 알아서 넣어줌
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                //logo
                const Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 50,
                ),
                //welcome back message
                const Text(
                  "환영합니다, 메신저에 로그인 해 주세요.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                //emailTextField
                MyTextField(
                  controller: emailController,
                  hintText: '이메일',
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                MyTextField(
                    controller: passwordController,
                    hintText: '비밀번호',
                    obscureText: true),

                const SizedBox(
                  height: 50,
                ),

                //sign in button
                MyButton(
                  onTap: signIn,
                  text: '로그인',
                ),

                const SizedBox(
                  height: 50,
                ),
                //not member? register in now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '회원이 아니신가요? ->',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        '회원 등록하기',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
