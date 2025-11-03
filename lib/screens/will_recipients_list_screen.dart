import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WillRecipientsListScreen extends StatefulWidget {
  const WillRecipientsListScreen({super.key, required String id});

  @override
  State<WillRecipientsListScreen> createState() =>
      _WillRecipientsListScreenState();
}

class _WillRecipientsListScreenState extends State<WillRecipientsListScreen> {
  List<dynamic> recipients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipients();
  }
  
  Future<void> fetchRecipients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await http.get(
        Uri.parse('http://kairoshk.ddns.net:3333/recipients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print('✅ 받은 데이터: $data');

        if (data is List) {
          setState(() {
            recipients = data;
            isLoading = false;
          });
        } else if (data is Map && data.containsKey('recipients')) {
          setState(() {
            recipients = data['recipients'];
            isLoading = false;
          });
        } else {
          print('⚠️ 예기치 못한 응답 구조: $data');
          setState(() => isLoading = false);
        }
      } else {
        print('❌ 요청 실패: ${res.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('⚠️ 오류 발생: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteRecipient(String recId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'http://kairoshk.ddns.net:3333/recipients/$recId';
    print('🗑️ DELETE 요청: $url');

    try {
      final res = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        print('✅ 전달자 삭제 성공');
        setState(() {
          recipients.removeWhere((r) => r['id'].toString() == recId);
        });
      } else {
        print('❌ 삭제 실패: ${res.statusCode}');
      }
    } catch (e) {
      print('⚠️ 삭제 중 오류 발생: $e');
    }
  }

  Future<void> updateRecipient(String recId, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'http://kairoshk.ddns.net:3333/recipients/$recId';
    print('✏️ PUT 요청: $url (이름: $newName)');

    try {
      final res = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': newName}),
      );

      if (res.statusCode == 200) {
        print('✅ 전달자 수정 성공');
        setState(() {
          final idx =
          recipients.indexWhere((r) => r['id'].toString() == recId);
          if (idx != -1) {
            recipients[idx]['name'] = newName;
          }
        });
      } else {
        print('❌ 수정 실패: ${res.statusCode}');
      }
    } catch (e) {
      print('⚠️ 수정 중 오류 발생: $e');
    }
  }

  void showDeleteConfirmDialog(String recId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제 확인'),
        content: Text('정말 "$name" 전달자를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteRecipient(recId);
            },
            child: const Text(
              '삭제',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void showEditDialog(String recId, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전달자 수정'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '이름',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context);
                await updateRecipient(recId, newName);
              }
            },
            child: const Text(
              '수정',
              style: TextStyle(color: Color(0xffFF834E)),
            ),
          ),
        ],
      ),
    );
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
                        padding: const EdgeInsets.only(left: 15),
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
                          '유서전달자 목록',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w800,
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
            const SizedBox(height: 30),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : recipients.isEmpty
                  ? const Center(
                child: Text(
                  '등록된 전달자가 없습니다.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    color: Color(0xff8B8888),
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recipients.length,
                itemBuilder: (context, index) {
                  final recipient = recipients[index];
                  final name = recipient['name'] ?? '이름 없음';
                  final recId = recipient['id'].toString();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xffED8B5E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => showEditDialog(recId, name),
                              child: const Icon(
                                Icons.edit,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => showDeleteConfirmDialog(
                                  recId, name),
                              child: const Icon(
                                Icons.delete,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
