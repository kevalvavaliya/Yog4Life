import 'package:flutter/material.dart';

class OTPBox extends StatelessWidget {
  FocusScopeNode _focusScopeNode = FocusScopeNode();
  TextEditingController controller;
  OTPBox({required this.controller});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 38,
      child: TextFormField(
        maxLength: 1,
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue))),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
