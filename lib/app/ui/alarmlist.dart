import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../controller/alarm_service.dart';
import '../controller/auth_service.dart';
import 'color.dart';
import 'login.dart';
import 'globalWidget.dart';

/// 홈페이지
class ArlamList extends StatefulWidget {
  const ArlamList({Key? key}) : super(key: key);

  @override
  State<ArlamList> createState() => _ArlamListState();
}

class _ArlamListState extends State<ArlamList> {
  @override
  Widget build(BuildContext context) {
    Get.put(AreaSelectController());

    final authService = context.read<AuthService>();

    return Consumer<AlarmService>(
      builder: (context, alarmService, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Palette.secondaryBackground,
            appBar: MainAppBarMethod(context, "대강 알림"),
            body: SlidingUpPanel(
              //boxShadow = BoxShadow(blurRadius: 8.0, color: Color.fromRGBO(0, 0, 0, 0.25)),
              backdropEnabled: false, //darken background if panel is open
              boxShadow: const <BoxShadow>[
                BoxShadow(blurRadius: 8.0, color: Colors.transparent),
              ],
              color: Colors
                  .transparent, //necessary if you have rounded corners for panel
              /// panel itself
              panel: Container(
                decoration: BoxDecoration(
                  // background color of panel
                  color: Palette.grayFF,
                  // rounded corners of panel
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0),
                    topRight: Radius.circular(6.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BarIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Pannel_expanded()
                  ],
                ),
              ),

              /// header of panel while collapsed
              collapsed: Container(
                decoration: BoxDecoration(
                  color: Palette.grayFF,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0),
                    topRight: Radius.circular(6.0),
                  ),
                ),
                child: Column(
                  children: [
                    BarIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Pannel_collaped()
                  ],
                ),
              ),

              /// widget behind panel
              body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                // stream: alarmService.read(user.uid),
                stream: FirebaseFirestore.instance
                    .collection('inprogress')
                    .orderBy('startTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  final controller = Get.find<AreaSelectController>();
                  // final documents = snapshot.data?.docs ?? []; // 문서들 가져오기
                  // final documents = snapshot.data; // 문서들 가져오기
                  List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];

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
                  return ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      physics: const RangeMaintainingScrollPhysics(),
                      itemCount: documents.length,
                      itemBuilder: (context, index) => Obx(
                        () {
                          final doc = documents[index];
                          String area = doc.get('area');
                          String status = doc.get('status');
                          bool areaFiltersflag = false;
                          List<String> areaFilters = [];

                          if (controller.selectedAreaList.contains("전국")) {
                            areaFiltersflag = true;
                          } else if (controller.selectedAreaList
                              .contains("기타")) {
                            List<String> areaFilters = [
                              "세종",
                              "전남",
                              "충북",
                              "충남",
                              "전북",
                              "제주",
                            ];
                            for (int i = 0; i < areaFilters.length; i++) {
                              if (area.contains(areaFilters[i]) == true) {
                                areaFiltersflag = true;
                              }
                            }
                          } else {
                            List<String> areaFilters =
                                controller.selectedAreaList;
                            for (int i = 0; i < areaFilters.length; i++) {
                              if (area.contains(areaFilters[i]) == true) {
                                areaFiltersflag = true;
                              }
                            }
                          }

                          // 지역 필터링 된 것들만 출력 하도록 설정
                          if (areaFiltersflag) {
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
                                .format(doc.get('startTime').toDate().toUtc())
                                .toString();
                            String startTimeGroup = dateFormatGroup
                                .format(doc.get('startTime').toDate().toUtc())
                                .toString();

                            bool isSameDate = true;

                            if (index == 0) {
                              isSameDate = false;
                            } else {
                              String preStartTimeGroup = dateFormatGroup
                                  .format(documents[index - 1]
                                      .get('startTime')
                                      .toDate()
                                      .toUtc())
                                  .toString();
                              if (preStartTimeGroup != startTimeGroup) {
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
                                        fontSize: 10, color: Color(0xFF737373)),
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
                          } else {
                            if ((index == 0)) {
                              initializeDateFormatting();
                              DateFormat dateFormat =
                                  DateFormat('aa hh:mm', 'ko');
                              DateFormat dateFormatGroup =
                                  DateFormat('yyyy년 M월 d일 E요일', 'ko');

                              String startTime = dateFormat
                                  .format(doc.get('startTime').toDate().toUtc())
                                  .toString();
                              String startTimeGroup = dateFormatGroup
                                  .format(doc.get('startTime').toDate().toUtc())
                                  .toString();

                              return Column(
                                children: [
                                  SizedBox(
                                    height: 31,
                                  ),
                                  Text(
                                    startTimeGroup,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xFF737373)),
                                  ),
                                  SizedBox(
                                    height: 31,
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox(width: 0, height: 0);
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class Pannel_expanded extends StatefulWidget {
  const Pannel_expanded({
    Key? key,
    //required this.areaChips,
  }) : super(key: key);

  @override
  State<Pannel_expanded> createState() => _Pannel_expandedState();
}

class _Pannel_expandedState extends State<Pannel_expanded> {
  //final List areaChips;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter stateSetter) {
      final controller = Get.find<AreaSelectController>();
      return Container(
          padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/bell.png",
                      width: 15,
                      height: 14,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "알림 설정",
                      style: TextStyle(fontSize: 14, color: Color(0xFF737373)),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFD2D2D2),
                height: 1,
                //width :
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/pick.png",
                      width: 15,
                      height: 13,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "알림 지역 변경하기",
                      style: TextStyle(fontSize: 14, color: Color(0xFF737373)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: GridView.builder(
                shrinkWrap: true,
                itemCount: controller.AreaList.length,
                itemBuilder: ((context, index) {
                  var value = controller.AreaList[index];

                  controller.initAreaColor(value);

                  // if (selectedAreaList.contains(value)) {
                  //   customTileColorList.add(Palette.backgroundBlue);
                  //   customBorderColorList.add(Colors.transparent);
                  //   // print("언제 울리니? 1 ");
                  // } else {
                  //   customTileColorList.add(Colors.transparent);
                  //   customBorderColorList.add(Palette.grayEE);
                  //   // print("언제 울리니? 2 ");
                  // }

                  // return Text(widget.optionList[index]);
                  return InkWell(
                    onTap: () {
                      stateSetter(
                        () {
                          setState(() {
                            controller.updateArea(value, index);
                          });
                        },
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: controller.customBorderColorList[index]),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: controller.customTileColorList[index]),
                        child: Center(
                            child: Text(
                          value,
                          style: TextStyle(fontSize: 14, color: Palette.gray33),
                        ))),
                  );
                }),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              )),
            ],
          ));
    });
  }
}

class Pannel_collaped extends StatefulWidget {
  const Pannel_collaped({
    Key? key,
    //required this.areaChips,
  }) : super(key: key);

  @override
  State<Pannel_collaped> createState() => _Pannel_collapedState();
}

class _Pannel_collapedState extends State<Pannel_collaped> {
  //final List areaChips;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter stateSetter) {
      return Container(
          padding: EdgeInsets.fromLTRB(13, 12, 13, 12),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/bell.png",
                      width: 15,
                      height: 14,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "알림 설정",
                      style: TextStyle(fontSize: 14, color: Color(0xFF737373)),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFD2D2D2),
                height: 1,
                //width :
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/pick.png",
                      width: 15,
                      height: 13,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "알림 지역 변경하기",
                      style: TextStyle(fontSize: 14, color: Color(0xFF737373)),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
}

class BarIndicator extends StatelessWidget {
  const BarIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: 34,
        height: 2,
        decoration: BoxDecoration(
          color: Color(0xFFA9A9A9),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
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
                              '${area}  |  ${shop}',
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
                              maxLines: 5,
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AreaSelectController {
  RxList<String> _AreaList = [
    "전국",
    "서울",
    "경기",
    "인천",
    "부산",
    "대전",
    "대구",
    "광주",
    "울산",
    "기타",
  ].obs;
  RxList<String> get AreaList => _AreaList;

  RxList<String> _selectedAreaList = ["서울"].obs;
  RxList<String> get selectedAreaList => _selectedAreaList;

  RxList _customTileColorList = [].obs;
  RxList get customTileColorList => _customTileColorList;

  RxList _customBorderColorList = [].obs;
  RxList get customBorderColorList => _customBorderColorList;

  void initAreaColor(value) {
    if (_selectedAreaList.contains(value)) {
      _customTileColorList.add(Palette.backgroundBlue);
      _customBorderColorList.add(Colors.transparent);
      // print("언제 울리니? 1 ");
    } else {
      _customTileColorList.add(Colors.transparent);
      _customBorderColorList.add(Palette.grayEE);
      // print("언제 울리니? 2 ");
    }
  }

  void updateArea(value, index) {
    if (_selectedAreaList.contains(value)) {
      _customTileColorList[index] = Colors.transparent;
      _customBorderColorList[index] = Palette.grayEE;
      _selectedAreaList.remove(value);
    } else {
      _customTileColorList[index] = Palette.backgroundBlue;
      _customBorderColorList[index] = Colors.transparent;
      _selectedAreaList.add(value);
    }
  }
}
