import 'package:flutter/material.dart';
import 'package:supperapp/widgets/colors/colors.dart';

class CustomButton extends StatelessWidget {
  final String btntext;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.btntext,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: tabColor,
        minimumSize: const Size(
          double.infinity,
          50,
        ),
      ),
      child: Text(
        btntext,
        style: const TextStyle(color: blackColor),
      ),
    );
  }
}
