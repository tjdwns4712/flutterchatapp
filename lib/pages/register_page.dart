import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  @override
  //controllers
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
      //AuthService로 부터 signUpWithEmailandPassword를 받아와 값을 넣음
    } catch (e) {
      // ignore: use_build_context_synchronously
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
      backgroundColor: Colors.grey[300],
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
                ),
                const SizedBox(
                  height: 50,
                ),
                //welcome back message
                const Text(
                  "Welcome back you've been missed",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                //emailTextField
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Password',
                    obscureText: true),

                const SizedBox(
                  height: 50,
                ),

                //sign up button
                MyButton(
                  onTap: signUp,
                  text: 'sign up',
                ),

                const SizedBox(
                  height: 50,
                ),
                //not member? register in now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?'),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
