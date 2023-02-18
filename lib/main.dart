import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/controller/auth_service.dart';
import 'app/controller/bucket_service.dart';
import 'app/controller/alarm_service.dart';
import 'app/ui/login.dart';
import 'firebase_options.dart';
import 'app/ui/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // firebase 앱 시작

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

    return MaterialApp(
        title: '클래스매치 대강알림',
        theme: ThemeData(
          fontFamily: 'Pretendard',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // initialBinding: BindingsBuilder(
        //   () {
        //     Get.put(NotificationController());
        //   },
        // ),
        debugShowCheckedModeBanner: false,
        home: LoginPage()
        // return user == null ? LoginPage() : MessagePage();

        );
  }
}
