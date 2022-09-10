import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utility {
  static showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3)));
  }
}
