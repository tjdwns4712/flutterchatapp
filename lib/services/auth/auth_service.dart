import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //instance of auth

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // _firebaseAuth는 Firebase Authentication 서비스의 인스턴스를 나타내는 객체

  // _firebaseFirestore Firebase Firestore 서비스의 인스턴스를 나타내는 객체

  //sign user in
  Future<UserCredential> signInwithEmailandPassword(
      String email, String password) async {
    //signInwithEmailandPassword는 email, password를 입력받아
    //firebase에 반환함으로서 인증작업을 진행한다.

    try {
      //sign in
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }
    //catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
      //오류 표시
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password) async {
    //signUpWithEmailandPassword은 email, password를 입력받아 등록 처리를 한다.
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        //firebaseAuth의 createUserWithEmailAndPassword를 사용해
        //등록을 처리하고, userCredential을 반환한다.
        email: email,
        password: password,
      );

      return userCredential;
    }
    //catch errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
      //오류 발생 시 코드를 리턴함.
    }
  }

  //sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
    //이 메소드는 파이어베이스 로그인을 로그아웃시킴.
  }
}
