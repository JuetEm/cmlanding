import 'package:classmatch/app/ui/message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app/controller/auth_service.dart';
import 'app/controller/bucket_service.dart';
import 'app/controller/alarm_service.dart';
import 'app/ui/alarmlist.dart';
import 'app/ui/login.dart';
import 'firebase_options.dart';

import 'app/ui/message_page.dart';
import 'app/ui/app.dart';
import 'app/controller/notification_controller.dart';
import 'app/ui/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // firebase 앱 시작

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '373f18bbec60b8e2d754cdb63ff12b32',
    javaScriptAppKey: '2ec57d1e5f1bdf8d161173e5086b828d',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BucketService()),
        ChangeNotifierProvider(create: (context) => AlarmService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();

    return GetMaterialApp(
      title: '베러코치 대강알림',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: BindingsBuilder(
        () {
          Get.put(NotificationController());
        },
      ),
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        // 메시지를 받으면 새로운 화면으로 전화하는 조건문
        if (NotificationController.to.remoteMessage.value.messageId != null) {
          //message
          return const ArlamList();
        }
        return user == null ? LoginPage() : ArlamList();
      }),
    );
  }
}
