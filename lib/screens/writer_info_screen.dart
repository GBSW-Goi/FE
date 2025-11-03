import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class WriterInfoScreen extends StatefulWidget {
  const WriterInfoScreen({super.key});

  @override
  State<WriterInfoScreen> createState() => _WriterInfoScreenState();
}

class _WriterInfoScreenState extends State<WriterInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _profileImageUrl;
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }



  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('⚠️ 이미지 선택 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> deleteImage() async {
    setState(() {
      _selectedImage = null;
      _profileImageUrl = null;
    });
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름과 이메일을 입력해주세요.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await http.put(
        Uri.parse('http://kairoshk.ddns.net:3333/my'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'birth': birthController.text.trim(),
          'phone': phoneController.text.trim(),
        }),
      );

      print('📤 프로필 수정 요청');
      print('📤 이름: ${nameController.text.trim()}');
      print('📤 이메일: ${emailController.text.trim()}');
      print('📤 생년월일: ${birthController.text.trim()}');
      print('📤 전화번호: ${phoneController.text.trim()}');
      print('📥 응답 코드: ${res.statusCode}');
      print('📥 응답 내용: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ 프로필이 저장되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ 저장 실패 (${res.statusCode})\n${res.body}')),
        );
      }
    } catch (e) {
      print('⚠️ 프로필 수정 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '회원 탈퇴',
          style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          '정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.',
          style: TextStyle(fontFamily: 'Pretendard'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(fontFamily: 'Pretendard')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '탈퇴',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        final res = await http.delete(
          Uri.parse('http://kairoshk.ddns.net:3333/my'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (res.statusCode == 200) {
          await prefs.remove('token');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ 회원 탈퇴가 완료되었습니다.')),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ 탈퇴 실패 (${res.statusCode})')),
          );
        }
      } catch (e) {
        print('⚠️ 회원 탈퇴 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('탈퇴 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xff4F4F4F),
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          '작성자 정보 보관함',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4F4F4F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 프로필 이미지
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffFF834E),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                            : _profileImageUrl != null
                            ? Image.network(
                          _profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person_outline,
                              size: 60,
                              color: Color(0xffFF834E),
                            );
                          },
                        )
                            : const Icon(
                          Icons.person_outline,
                          size: 60,
                          color: Color(0xffFF834E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF834E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '이미지 선택',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: deleteImage,
                      child: const Text(
                        '이미지 삭제',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4F4F4F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '이름',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4F4F4F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: '홍길동',
                        hintStyle: const TextStyle(
                          color: Color(0xff8B8888),
                          fontFamily: 'Pretendard',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: nameController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Color(0xff8B8888),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              nameController.clear();
                            });
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffFF834E),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '생년월일',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4F4F4F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: birthController,
                      decoration: InputDecoration(
                        hintText: '1999 . 01 . 25',
                        hintStyle: const TextStyle(
                          color: Color(0xff8B8888),
                          fontFamily: 'Pretendard',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: birthController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Color(0xff8B8888),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              birthController.clear();
                            });
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffFF834E),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '전화번호',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4F4F4F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: '',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: phoneController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Color(0xff8B8888),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              phoneController.clear();
                            });
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffFF834E),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '이메일',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4F4F4F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: '',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: emailController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Color(0xff8B8888),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              emailController.clear();
                            });
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffFF834E),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFF834E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          '저장하기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: deleteAccount,
                      child: const Text(
                        '회원 탈퇴하기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4F4F4F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}