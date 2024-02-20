import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//사용자의 이메일, 비밀번호, 비밀번호 확인을 입력받고 사용자 등록 처리를 한다.

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  @override
  //입력 컨트롤러
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      //passwordController로 입력받은 값이 confirmPasswordController와 같지 않다면
      //Passwodr do not match! 메시지를 출력
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passwodr do not match!',
          ),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    //authService는 Provider를 이용하여 AuthService클래스에서 인스턴스를 받아옴.

    try {
      await authService.signUpWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
      //AuthService로 부터 signUpWithEmailandPassword를 불러 사용자 등록을 진행함
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            //예외가 발생하면 SnackBar메시지로 오류 표시
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
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(
                  height: 50,
                ),
                //welcome back message
                const Text(
                  "회원 가입을 환영합니다.",
                  style: TextStyle(
                    fontSize: 18,
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
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                MyTextField(
                    controller: passwordController,
                    hintText: '비밀번호',
                    obscureText: true),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: '비밀번호 확인',
                    obscureText: true),

                const SizedBox(
                  height: 50,
                ),

                //sign up button
                MyButton(
                  onTap: signUp,
                  text: '회원가입',
                ),

                const SizedBox(
                  height: 50,
                ),
                //not member? register in now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '이미 회원이신가요? ->',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      //터치를 하면 LoginOrRegister가 터치를 인식해 페이지를 이동시킨다.
                      child: const Text(
                        '로그인하기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
