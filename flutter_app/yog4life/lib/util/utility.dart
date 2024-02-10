import 'package:flutter/material.dart';

class Utility {
  static const String URL = 'https://yog4life-server.onrender.com';

  static showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Rubik', color: Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 3)));
  }
}
