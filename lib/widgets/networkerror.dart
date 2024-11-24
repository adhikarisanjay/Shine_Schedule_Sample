import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:shine_schedule/widgets/custom_button.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String image;
  final String text;

  const NetworkErrorWidget(
      {Key? key,
      required this.onRetry,
      required this.text,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            image, // Update with your actual image asset path
            height: 300,
          ),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red, // Update with your desired color
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onTap: onRetry,
            label: "Retry",
          ),
        ],
      ),
    );
  }
}
