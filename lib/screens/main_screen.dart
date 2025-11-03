import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:programming/screens/will_container_screen.dart';
import 'package:programming/screens/will_list.dart';
import 'package:programming/screens/write_screen.dart';
import 'package:programming/screens/writer_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    getMyInfo();
  }

  String name = '';
  int will = 0;
  String willStatus = '';

  Future<void> getMyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('http://kairoshk.ddns.net:3333/my'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        name = data['user']['name'];
        will = data['user']['stats']['wills'];
        willStatus = data['user']['stats']['will_status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF834E),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Group 2.png', width: 43),
                        SizedBox(width: 5),
                        Text(
                          '고이',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Gugi",
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/setting.png',
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 20),
                    will.bitLength == 0
                        ? Text(
                            '아직 작성된 유서 정보가 없습니다.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          )
                        : Text(
                            willStatus,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        if (will.bitLength == 0) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WriteScreen(),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WillContainerScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          will.bitLength == 0
                              ? Text(
                                  '유서 작성하기',
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  '유서 확인하기',
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 400),
            child: Container(
              width: double.infinity,
              height: 500,
              color: Color(0xffFFFDFA),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 300),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WriteScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 155,
                        height: 185,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/Group 57.png',
                                width: 60,
                              ),
                              SizedBox(height: 30),
                              Text(
                                '유서 작성하기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '생전 유서 작성',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Color(0xff8B8888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WriterInfoScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 155,
                        height: 185,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/face.png', width: 50),
                              SizedBox(height: 30),
                              Text(
                                '작성자 정보 보관함',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '유서 작성자 정보 보관',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Color(0xff8B8888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WillContainerScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 155,
                        height: 185,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/box.png', width: 50),
                              SizedBox(height: 30),
                              Text(
                                '유서 보관함',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '생전 유서 보관 및 수정',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Color(0xff8B8888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WillListScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 155,
                        height: 185,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/send.png', width: 50),
                              SizedBox(height: 30),
                              Text(
                                '유서 전달하기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '유서 전달자 정보 작성',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Color(0xff8B8888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
