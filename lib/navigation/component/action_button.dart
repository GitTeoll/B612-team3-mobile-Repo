import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final double size;
  final String content;
  final void Function() ontap;

  const ActionButton({
    super.key,
    required this.size,
    required this.content,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 186, 237, 140),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Center(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
