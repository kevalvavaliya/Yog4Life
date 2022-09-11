import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorYogaMan extends StatelessWidget {
  final String msg;
  Widget? reload;
  ErrorYogaMan({required this.msg, this.reload});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Lottie.asset('assets/lottie/yogaman.json'),
        ),
        Text(
          msg,
          style: const TextStyle(
              fontSize: 20, fontFamily: 'Rubik', fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        if (reload != null) reload as Widget
      ],
    );
  }
}
