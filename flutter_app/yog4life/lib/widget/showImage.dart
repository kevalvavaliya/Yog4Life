import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  Widget child;
  ShowImage({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          clipBehavior: Clip.hardEdge,
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: child),
    );
  }
}
