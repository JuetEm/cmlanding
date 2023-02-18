import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlarmService extends ChangeNotifier {
  //final alarmCollection = FirebaseFirestore.instance.collection('live');
  final alarmCollection = FirebaseFirestore.instance.collection('inprogress');
  final emailCollection = FirebaseFirestore.instance.collection('email');

  Future<int> countMember() async {
    QuerySnapshot docRaw = await emailCollection.get();
    List<DocumentSnapshot> docs = docRaw.docs;
    print('[LS] countMember 실행 - pos : ${docs.length}');
    return docs.length;
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> read(String uid) async* {
  //   // 내 bucketList 가져오기
  //   // yield alarmCollection.orderBy('startTime', descending: true).snapshots();
  // }
  void create({
    required String phoneNumber,
    required String name,
    required String email,
    required bool isChecked,
    required Function onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    // 이메일 및 비밀번호 입력 여부 확인
    if (name.isEmpty) {
      onError("이름을 입력해 주세요.");
      return;
    } else if (email.isEmpty) {
      onError("이메일을 입력해 주세요.");
      return;
    } else if (!regex.hasMatch(email)) {
      onError("잘못된 이메일 형식입니다.");
      return;
    } else if (phoneNumber.isEmpty) {
      onError("전화번호를 입력해 주세요.");
      return;
    } else if (isChecked == false) {
      onError("개인정보 수집 및 활용에 동의 하셔야 신청할 수 있습니다.");
      return;
    }

    // firebase auth 회원 가입
    try {
      await emailCollection.add({
        'phoneNumber': phoneNumber, // 전화번호
        'name': name, // 이름
        'email': email, // 이메일
      });
      // 성공 함수 호출
      onSuccess();
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }

    notifyListeners(); // 화면 갱신
  }
}
