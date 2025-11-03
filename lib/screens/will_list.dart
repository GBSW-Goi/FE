import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:programming/screens/send_will_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WillListScreen extends StatefulWidget {
  const WillListScreen({super.key});

  @override
  State<WillListScreen> createState() => _WillListScreenState();
}

class _WillListScreenState extends State<WillListScreen> {
  List<dynamic> wills = [];
  String id = '';
  bool isLoading = true;
  String? expandedWillId;

  @override
  void initState() {
    super.initState();
    getWillInfo();
  }

  Future<void> getWillInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await http.get(
        Uri.parse('http://kairoshk.ddns.net:3333/wills'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data);
        setState(() {
          wills = data['wills'];
          print(id);
          isLoading = false;
        });
      } else {
        print('❌ 실패: ${res.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('⚠️ 오류 발생: $e');
      setState(() => isLoading = false);
    }
  }

  String formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.year}. ${dateTime.month}. ${dateTime.day} (${_getKoreanWeekday(dateTime.weekday)}) 오후 ${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  String _getKoreanWeekday(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[(weekday - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFDFA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 25,
                              color: Color(0xff4F4F4F),
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          '유서 선택',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xff4F4F4F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : wills.isEmpty
                  ? const Center(
                      child: Text(
                        '작성된 유서가 없습니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          color: Color(0xff8B8888),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: wills.length,
                      itemBuilder: (context, index) {
                        final will = wills[index];
                        final willId = will['id'];
                        print(willId);
                        final isExpanded = expandedWillId == will['id'];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SendWillScreen(id: willId),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFF834E),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatDate(will['created_at']),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Pretendard',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          will['title'] ?? '제목 없음',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Pretendard',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
