import 'package:flutter/material.dart';

import '../store.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      store.startAnimation(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF834E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '당신의 마지막 순간을 영원을 기억할 수 있도록',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            SizedBox(height: 15),
            Text(
              '고이',
              style: TextStyle(
                fontFamily: "Gugi",
                fontSize: 43,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Image.asset('assets/images/Group 2.png'),
          ],
        ),
      ),
    );
  }
}
