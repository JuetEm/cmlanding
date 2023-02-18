import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../controller/alarm_service.dart';
import '../controller/auth_service.dart';
import 'color.dart';
import 'globalWidget.dart';

Color focusColor = Palette.buttonOrange;
Color normalColor = Palette.gray66;
bool initFlag = true;
bool finishFlag = false;

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  FocusNode emailFocusNode = new FocusNode();
  FocusNode nameFocusNode = new FocusNode();
  FocusNode phoneNumberFocusNode = new FocusNode();

  bool _isChecked = false;

  final GlobalKey directKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmService>(
      builder: (context, alramService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser();
        // Future<int> count = alramService.countMember();

        if (initFlag == true) {
          //자동 로그인
          authService.signIn(
            email: "demo@demo.com",
            password: "123456",
            onSuccess: () {
              // 로그인 성공
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("로그인 성공"),
              // ));
            },
            onError: (err) {
              // // 에러 발생
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(err),
              // ));
            },
          );
          initFlag = false;
        }

        return Scaffold(
          // appBar: AppBar(title: Text("로그인")),
          body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(14.0),
                      //     child: Container(
                      //         width: 200,
                      //         child: Center(
                      //           child: Text(" 무료 체험 바로가기",
                      //               style: TextStyle(fontSize: 24)),
                      //         )),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     padding: EdgeInsets.all(0),
                      //     elevation: 0,
                      //     backgroundColor: Palette.buttonOrange,
                      //   ),
                      //   onPressed: () {
                      //     Scrollable.ensureVisible(
                      //       directKey.currentContext!,
                      //       duration: Duration(seconds: 1),
                      //     );
                      //   },
                      // ),

                      // 랜딩페이지 이미지
                      Image.asset(
                        'assets/images/Landing_01.png',
                        width: 360,
                        // height: 4000,
                        // fit: BoxFit.cover,
                      ),
                      InkWell(
                        child: Image.asset(
                          'assets/images/Landing_03.png',
                          width: 360,
                          // height: 4000,
                          // fit: BoxFit.cover,
                        ),
                        onTap: () {
                          Scrollable.ensureVisible(
                            directKey.currentContext!,
                            duration: Duration(seconds: 1),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.grayEE, width: 1),
                          // borderRadius: BorderRadius.only(
                          //   topRight: Radius.circular(10),
                          //   topLeft: Radius.circular(10),
                          //   bottomLeft: Radius.circular(10),
                          //   bottomRight: Radius.circular(10),
                          // ),
                          //color: Palette.grayFF,
                        ),
                        height: 800,
                        child: Column(children: [
                          Container(
                            height: 50,
                            width: 360,
                            color: Palette.mainBackground,
                            child: Center(
                              child: Text(
                                "대강알림",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.gray00,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            // stream: alarmService.read(user.uid),
                            stream: FirebaseFirestore.instance
                                .collection('inprogress2')
                                .orderBy('startTime', descending: true)
                                .limit(3)
                                .snapshots(),
                            builder: (context, snapshot) {
                              // final controller =
                              //     Get.find<AreaSelectController>();
                              // final documents = snapshot.data?.docs ?? []; // 문서들 가져오기
                              // final documents = snapshot.data; // 문서들 가져오기
                              List<DocumentSnapshot> documents =
                                  snapshot.data?.docs ?? [];

                              // List<DocumentSnapshot> documents = snapshot.data!.docs;
                              if (snapshot.hasError) {
                                return Center(child: Text("회원 목록을 준비 중입니다."));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Text("회원 목록을 준비 중입니다."));
                              } else if (!snapshot.hasData) {
                                return Center(child: Text("회원 목록을 준비 중입니다."));
                              }
                              // if (documents.isEmpty) {
                              //   return Center(child: Text("회원 목록을 준비 중입니다."));
                              // }
                              return SingleChildScrollView(
                                // physics: const RangeMaintainingScrollPhysics(),
                                child: Column(
                                  children: [
                                    // Image.asset(
                                    //   'assets/images/landing.png',
                                    //   width: 410,
                                    //   // height: 4000,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        final doc = documents[index];
                                        String area = doc.get('area');
                                        String status = doc.get('status');
                                        // bool areaFiltersflag = false;
                                        // List<String> areaFilters = [];

                                        // if (controller.selectedAreaList
                                        //     .contains("전국")) {
                                        //   areaFiltersflag = true;
                                        // } else if (controller.selectedAreaList
                                        //     .contains("기타")) {
                                        //   List<String> areaFilters = [
                                        //     "세종",
                                        //     "전남",
                                        //     "충북",
                                        //     "충남",
                                        //     "전북",
                                        //     "제주",
                                        //   ];
                                        //   for (int i = 0;
                                        //       i < areaFilters.length;
                                        //       i++) {
                                        //     if (area.contains(areaFilters[i]) ==
                                        //         true) {
                                        //       areaFiltersflag = true;
                                        //     }
                                        //   }
                                        // } else {
                                        //   List<String> areaFilters =
                                        //       controller.selectedAreaList;
                                        //   for (int i = 0;
                                        //       i < areaFilters.length;
                                        //       i++) {
                                        //     if (area.contains(areaFilters[i]) ==
                                        //         true) {
                                        //       areaFiltersflag = true;
                                        //     }
                                        //   }
                                        // }

                                        // 지역 필터링 된 것들만 출력 하도록 설정
                                        // if (areaFiltersflag) {
                                        String title = doc.get('title');
                                        String date = doc.get('date');
                                        String author = doc.get('author');
                                        String shop = doc.get('shop');
                                        String fee = doc.get('fee');
                                        // print(doc.get('content'));
                                        // print(doc.get('content').runtimeType);
                                        String content = doc.get('content');
                                        // String contentStr = jsonDecode(content).join(",");

                                        initializeDateFormatting();
                                        DateFormat dateFormat =
                                            DateFormat('aa hh:mm', 'ko');
                                        DateFormat dateFormatGroup =
                                            DateFormat('yyyy년 M월 d일 E요일', 'ko');

                                        String startTime = dateFormat
                                            .format(doc
                                                .get('startTime')
                                                .toDate()
                                                .toUtc())
                                            .toString();
                                        String startTimeGroup = dateFormatGroup
                                            .format(doc
                                                .get('startTime')
                                                .toDate()
                                                .toUtc())
                                            .toString();

                                        bool isSameDate = true;

                                        if (index == 0) {
                                          isSameDate = false;
                                        } else {
                                          String preStartTimeGroup =
                                              dateFormatGroup
                                                  .format(documents[index - 1]
                                                      .get('startTime')
                                                      .toDate()
                                                      .toUtc())
                                                  .toString();
                                          if (preStartTimeGroup !=
                                              startTimeGroup) {
                                            isSameDate = false;
                                          }
                                        }

                                        if (index == 0 || !(isSameDate)) {
                                          // 날짜와 같이 출력
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                startTimeGroup,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF737373)),
                                              ),
                                              SizedBox(
                                                height: 31,
                                              ),
                                              MessageBubble(
                                                title: title,
                                                area: area,
                                                date: date,
                                                author: author,
                                                shop: shop,
                                                fee: fee,
                                                startTime: startTime,
                                                content: content,
                                                status: status,
                                              ),
                                            ],
                                          );
                                        } else {
                                          // 메시지 버블만 출력
                                          return MessageBubble(
                                            title: title,
                                            area: area,
                                            date: date,
                                            author: author,
                                            shop: shop,
                                            fee: fee,
                                            startTime: startTime,
                                            content: content,
                                            status: status,
                                          );
                                        }
                                        // } else {
                                        //   if ((index == 0)) {
                                        //     initializeDateFormatting();
                                        //     DateFormat dateFormat =
                                        //         DateFormat('aa hh:mm', 'ko');
                                        //     DateFormat dateFormatGroup =
                                        //         DateFormat(
                                        //             'yyyy년 M월 d일 E요일', 'ko');

                                        //     String startTime = dateFormat
                                        //         .format(doc
                                        //             .get('startTime')
                                        //             .toDate()
                                        //             .toUtc())
                                        //         .toString();
                                        //     String startTimeGroup =
                                        //         dateFormatGroup
                                        //             .format(doc
                                        //                 .get('startTime')
                                        //                 .toDate()
                                        //                 .toUtc())
                                        //             .toString();

                                        //     return Column(
                                        //       children: [
                                        //         SizedBox(
                                        //           height: 31,
                                        //         ),
                                        //         Text(
                                        //           startTimeGroup,
                                        //           overflow: TextOverflow.clip,
                                        //           maxLines: 1,
                                        //           style: TextStyle(
                                        //               fontSize: 10,
                                        //               color: Color(0xFF737373)),
                                        //         ),
                                        //         SizedBox(
                                        //           height: 31,
                                        //         ),
                                        //       ],
                                        //     );
                                        //   } else {
                                        //     return SizedBox(
                                        //         width: 0, height: 0);
                                        //   }
                                        // }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                      Image.asset(
                        'assets/images/Landing_04.png',
                        width: 360,
                        // height: 4000,
                        // fit: BoxFit.cover,
                      ),

                      Container(
                        key: directKey,
                        width: 250,
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: nameController,
                            // obscureText: false, // 비밀번호 안보이게
                            style: TextStyle(color: normalColor),
                            decoration: InputDecoration(
                              labelText: "이름",
                              labelStyle: TextStyle(
                                  color: nameFocusNode.hasFocus
                                      ? focusColor
                                      : normalColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.gray33, width: 0),
                              ),
                              focusColor: focusColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: focusColor,
                                ),
                              ),
                            ),
                          ),

                          /// 이메일
                          TextField(
                            controller: emailController,
                            style: TextStyle(color: normalColor),
                            decoration: InputDecoration(
                              labelText: "이메일",
                              labelStyle: TextStyle(
                                  color: emailFocusNode.hasFocus
                                      ? focusColor
                                      : normalColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.gray33, width: 0),
                              ),
                              focusColor: focusColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: focusColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          /// 전화번호
                          TextField(
                            controller: phoneNumberController,
                            // obscureText: false, // 비밀번호 안보이게

                            style: TextStyle(color: normalColor),
                            decoration: InputDecoration(
                              labelText: "휴대폰번호",
                              labelStyle: TextStyle(
                                  color: phoneNumberFocusNode.hasFocus
                                      ? focusColor
                                      : normalColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.gray33, width: 0),
                              ),
                              focusColor: focusColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: focusColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자만!
                              NumberFormatter(), // 자동하이픈
                              LengthLimitingTextInputFormatter(
                                  13) //13자리만 입력받도록 하이픈 2개+숫자 11개
                            ],
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            // ],
                          ),

                          SizedBox(height: 10),
                          Text("개인정보 수집 및 활용에 동의하십니까?"),
                          SizedBox(height: 10),

                          Container(
                            width: 200,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    }),
                                Text("네"),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            // stream: alarmService.read(user.uid),
                            stream: FirebaseFirestore.instance
                                .collection('email')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<DocumentSnapshot> documents =
                                  snapshot.data?.docs ?? [];
                              // List<DocumentSnapshot> documents = snapshot.data!.docs;
                              if (snapshot.hasError) {
                                return Center(child: Text("-"));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Text("-"));
                              } else if (!snapshot.hasData) {
                                return Center(child: Text("-"));
                              }
                              int count = 30 - documents.length;
                              if (count < 0) {
                                count = 0;
                                finishFlag = true;
                              }
                              return Column(
                                children: [
                                  Text("남은자리 : ${count.toString()}",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Offstage(
                                    offstage: !finishFlag,
                                    child: ElevatedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 200,
                                          child: Center(
                                            child: Text("대기 알림 받기",
                                                style: TextStyle(fontSize: 24)),
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: EdgeInsets.all(0),
                                        elevation: 0,
                                        backgroundColor: Palette.buttonOrange,
                                      ),
                                      onPressed: () {
                                        // null;
                                        // 회원가입
                                        alramService.create(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          isChecked: _isChecked,
                                          onSuccess: () {
                                            nameController.clear();
                                            emailController.clear();
                                            phoneNumberController.clear();

                                            FlutterDialog(
                                                context, "대기알림 신청 완료되었습니다");

                                            // // 회원가입 성공
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text("무료 체험 신청이 완료되었습니다"),
                                            // ));
                                          },
                                          onError: (err) {
                                            FlutterDialog(context, err);
                                            // // 에러 발생
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text(err),
                                            // ));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Offstage(
                                    offstage: finishFlag,
                                    child: ElevatedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Container(
                                          width: 200,
                                          child: Center(
                                            child: Text("무료 체험 신청",
                                                style: TextStyle(fontSize: 24)),
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: EdgeInsets.all(0),
                                        elevation: 0,
                                        backgroundColor: Palette.buttonOrange,
                                      ),
                                      onPressed: () {
                                        // null;
                                        // 회원가입
                                        alramService.create(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          isChecked: _isChecked,
                                          onSuccess: () {
                                            nameController.clear();
                                            emailController.clear();
                                            phoneNumberController.clear();

                                            FlutterDialog(
                                                context, "무료 체험 신청이 완료되었습니다");

                                            // // 회원가입 성공
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text("무료 체험 신청이 완료되었습니다"),
                                            // ));
                                          },
                                          onError: (err) {
                                            FlutterDialog(context, err);
                                            // // 에러 발생
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text(err),
                                            // ));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 20),

                          SizedBox(height: 50),
                        ]),
                      )

                      /// 이름

                      // /// 회원가입 버튼
                      // ElevatedButton(
                      //     child: Text("카카오 로그인", style: TextStyle(fontSize: 21)),
                      //     onPressed: () async {
                      //       if (await isKakaoTalkInstalled()) {
                      //         try {
                      //           await UserApi.instance.loginWithKakaoTalk();
                      //           print('카카오톡으로 로그인 성공');
                      //           _get_user_info();
                      //           // HomePage로 이동
                      //           Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => ArlamList()),
                      //           );
                      //         } catch (error) {
                      //           print('카카오톡으로 로그인 실패 $error');
                      //           // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                      //           try {
                      //             await UserApi.instance.loginWithKakaoAccount();
                      //             print('카카오계정으로 로그인 성공');
                      //             _get_user_info();
                      //             // HomePage로 이동
                      //             Navigator.pushReplacement(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => ArlamList()),
                      //             );
                      //           } catch (error) {
                      //             print('카카오계정으로 로그인 실패 $error');
                      //           }
                      //         }
                      //       } else {
                      //         try {
                      //           await UserApi.instance.loginWithKakaoAccount();
                      //           print('카카오계정으로 로그인 성공');
                      //           _get_user_info();
                      //           // HomePage로 이동
                      //           Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => ArlamListOld()),
                      //           );
                      //         } catch (error) {
                      //           print('카카오계정으로 로그인 실패 $error');
                      //         }
                      //       }
                      //     }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.customController,
    required this.hint,
    required this.width,
    required this.height,
    required this.customFunction,
    required this.isSecure,
  }) : super(key: key);

  final TextEditingController customController;
  final String hint;
  final double width;
  final double height;
  final bool isSecure;
  final Function customFunction;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = new FocusNode();
    Color focusColor = Palette.buttonOrange;
    Color normalColor = Palette.gray66;

    return TextField(
      controller: widget.customController,
      onSubmitted: widget.customFunction(),
      obscureText: widget.isSecure, // 비밀번호여부
      style: TextStyle(color: normalColor),
      decoration: InputDecoration(
        labelText: widget.hint,
        labelStyle:
            TextStyle(color: myFocusNode.hasFocus ? focusColor : normalColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Palette.gray33, width: 0),
        ),
        focusColor: focusColor,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusColor,
          ),
        ),
      ),
    );
  }
}

void FlutterDialog(context, bodytext) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          // title: Column(
          //   children: <Widget>[
          //     new Text("Dialog Title"),
          //   ],
          // ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                bodytext,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.title,
    required this.area,
    required this.date,
    required this.author,
    required this.shop,
    required this.fee,
    required this.startTime,
    required this.content,
    required this.status,
  }) : super(key: key);

  final String title;
  final String area;
  final String date;
  final String author;
  final String shop;
  final String fee;
  final String startTime;
  final String content;
  final String status;

  @override
  Widget build(BuildContext context) {
    // String contentStr = content.join(",");

    if (status == "진행중") {
      return Column(
        children: [
          Container(
            //color: Palette.gray33,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                // 서클 아이콘
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //height: double.infinity,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Palette.grayFF,
                        backgroundImage:
                            AssetImage("assets/images/bettercoach_icon.png"),
                      ),
                    ),
                    //Spacer(flex: 1)
                  ],
                ),
                //SizedBox(width: 30),
                SizedBox(width: 7),
                // 메시지 버블
                // Image.asset("assets/images/bettercoach_icon.png", width: 30),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      width: 233,
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.grayFF, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Palette.grayFF,
                      ),
                      child: Column(
                        children: [
                          //SizedBox(height: 4),
                          Container(
                            width: 203,
                            child: Text(
                              title,
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF737373)),
                            ),
                          ),
                          SizedBox(height: 14),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE1E1E1),
                            ),
                            child: SizedBox(
                              width: 203,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 9),
                          Container(
                            width: 203,
                            child: Text(
                              '${area}  | ',
                              // '${area}  |  ${shop}',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF000000)),
                            ),
                          ),
                          Container(
                            width: 203,
                            child: Text(
                              '${date}  |  페이 : ${fee}',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF000000)),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE1E1E1),
                            ),
                            child: SizedBox(
                              width: 203,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 11),
                          Container(
                            width: 203,
                            child: Text(
                              '${content}',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF737373)),
                            ),
                          ),
                          //SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      startTime,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        // color: isDone ? Colors.grey : Colors.black,
                        // decoration: isDone
                        //     ? TextDecoration.lineThrough
                        //     : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 1)
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            //color: Palette.gray33,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                // 서클 아이콘
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //height: double.infinity,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Palette.grayFF,
                        backgroundImage:
                            AssetImage("assets/images/bettercoach_icon.png"),
                      ),
                    ),
                    //Spacer(flex: 1)
                  ],
                ),
                //SizedBox(width: 30),
                SizedBox(width: 7),
                // 메시지 버블
                // Image.asset("assets/images/bettercoach_icon.png", width: 30),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      width: 233,
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.grayFF, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Palette.grayFF,
                      ),
                      child: Column(
                        children: [
                          //SizedBox(height: 4),
                          Container(
                            width: 203,
                            child: Text(
                              '완료된 모집 공고입니다.',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFBABABA)),
                            ),
                          ),
                          SizedBox(height: 14),
                          Container(
                            width: 203,
                            child: Text(
                              title,
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFBABABA)),
                            ),
                          ),
                          SizedBox(height: 14),
                          Container(
                            width: 203,
                            child: Text(
                              '${area}  |  ${shop}',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFBABABA)),
                            ),
                          ),

                          //SizedBox(height: 8),

                          //SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      startTime,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        // color: isDone ? Colors.grey : Colors.black,
                        // decoration: isDone
                        //     ? TextDecoration.lineThrough
                        //     : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 1)
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      );
    }
  }
}
