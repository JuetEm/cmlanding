import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'message_page.dart';
import 'package:get/get.dart';

import '../controller/notification_controller.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase cloud Message"),
      ),
      body: Obx(() {
        // 메시지를 받으면 새로운 화면으로 전화하는 조건문
        if (NotificationController.to.remoteMessage.value.messageId != null) {
          //message
          return const MessagePage();
        }
        return const Center(
          child: Text('Firebase cloud Message'),
        );
      }),
    );
  }
}
