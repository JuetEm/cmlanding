import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlarmService extends ChangeNotifier {
  //final alarmCollection = FirebaseFirestore.instance.collection('live');
  final alarmCollection = FirebaseFirestore.instance.collection('inprogress');

  // Stream<QuerySnapshot<Map<String, dynamic>>> read(String uid) async* {
  //   // 내 bucketList 가져오기
  //   // yield alarmCollection.orderBy('startTime', descending: true).snapshots();
  // }
}
