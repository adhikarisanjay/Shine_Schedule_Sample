import 'package:flutter/material.dart';
import 'package:shine_schedule/utils/colors.dart';

class CircularButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CircularButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: ShineColors.appMainColor,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
