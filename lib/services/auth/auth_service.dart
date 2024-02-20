import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//이 페이지는 기존 사용자 인증, 새로운 사용자 등록 로직을 처리해주는 페이지이다.

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // _firebaseAuth는 Firebase Authentication 서비스의 인스턴스를 나타내는 객체

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // _firebaseFirestore Firebase Firestore 서비스의 인스턴스를 나타내는 객체

  //로그인 인증
  Future<UserCredential> signInwithEmailandPassword(
      String email, String password) async {
    //signInwithEmailandPassword는 email, password를 입력받아
    //firebase에 반환함으로서 인증작업을 진행한다.

    try {
      //사용자 인증
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //아직 컬랙션이 없는 사용자를 위한 도큐먼트 추가
      _firestore.collection('uesrs').doc(userCredential.user!.uid).set({
        // uesrs컬랙션 내 uid가 현재 사용자 uid인 곳에서, uid를 형재 사용자 uid로
        // email을 email로 설정한다.
        // 인증이 완료된 사용자는 컬랙션에 추가하여 채팅에서 활용할 데이터에 넣는다

        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
      // merge: true를 통해 갱신이 아닌 병합을 한다.(완전히 새로운 데이터를 넣는것이 아닌 변한 부분만 바꿈)

      return userCredential;
    }
    //catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
      //오류 표시
    }
  }

  //새로운 유저 생성
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password) async {
    //signUpWithEmailandPassword은 email, password를 입력받는다.

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        //firebaseAuth의 createUserWithEmailAndPassword를 사용해
        //등록을 처리하고, userCredential을 반환한다.
        email: email,
        password: password,
      );

      //유저생성 후 새로운 유저 컬랙션을 위한 도큐먼트 만들기
      _firestore.collection('uesrs').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }); // firestore에 넣어 향후 사용할 데이터 컬랙션에 추가한다.

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
