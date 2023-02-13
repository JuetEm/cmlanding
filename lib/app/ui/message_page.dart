import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controller/auth_service.dart';
import '../../main.dart';
import '../controller/notification_controller.dart';
import 'alarmlist.dart';
import 'login.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('MessagePage >> build');
    // TextEditingController _idController;
    // _idController = TextEditingController();
    // _idController.text = token_g;
    return Scaffold(
      appBar: AppBar(
        title: Text("대강 구인 모집 리스트2"),
        actions: [
          TextButton(
            child: Text(
              "로그아웃",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // 로그아웃
              context.read<AuthService>().signOut();

              // 로그인 페이지로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          TextButton(
            child: Text(
              "리스트 보기",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // 로그인 페이지로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ArlamList()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextField(
                //   decoration: InputDecoration(labelText: 'Enter Message'),
                //   controller: _idController,
                //   keyboardType: TextInputType.multiline,
                //   minLines: 1, // <-- SEE HERE
                //   maxLines: 5, // <-- SEE HERE
                // ),
                Text(
                  token_g.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  NotificationController
                      .to.remoteMessage.value.notification!.title
                      .toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  NotificationController
                      .to.remoteMessage.value.notification!.body
                      .toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  NotificationController.to.dateTime.value.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
