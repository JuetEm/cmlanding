import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_service.dart';
import 'color.dart';
import 'login.dart';

AppBar MainAppBarMethod(BuildContext context, String pageName) {
  return AppBar(
    elevation: 0,
    backgroundColor: Palette.mainBackground,
    title: Text(
      pageName,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Palette.gray00,
          ),
    ),
    centerTitle: true,
    // leading: IconButton(
    //   onPressed: () {},
    //   icon: Icon(Icons.calendar_month),
    // ),
    actions: [
      // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))

      TextButton(
        child: Text(
          "로그아웃",
          style: TextStyle(
            color: Colors.black,
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
      // IconButton(
      //   onPressed: () {
      //     print('profile');
      //     // 로그인 페이지로 이동
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => LoginPage()),
      //     );
      //   },
      //   color: Palette.gray33,
      //   icon: Icon(Icons.account_circle),
      // ),
      // IconButton(
      //   onPressed: () {
      //     _openEndDrawer();
      //   },
      //   icon: Icon(Icons.menu),
      // ),
    ],
  );
}
