import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required bool isSuccess,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color:
            isSuccess
                ? const Color(0xFF155724) // success text
                : const Color(0xFF721C24), // error text
      ),
    ),
    backgroundColor:
        isSuccess
            ? const Color(0xFFD4EDDA) // success background
            : const Color(0xFFF8D7DA), // error background,
    behavior: SnackBarBehavior.floating,
    elevation: 4,
    duration: const Duration(seconds: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showCustomSnackBarWithWidth({
  required BuildContext context,
  required double width,
  required String message,
  required bool isSuccess,
}) {
  final double screenWidth = MediaQuery.of(context).size.width;

  final snackBar = SnackBar(
    // Does not take up full screen
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: const Duration(seconds: 2),
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // Adjust width
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0001),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFFD4EDDA) : const Color(0xFFF8D7DA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: isSuccess ? const Color(0xFF155724) : const Color(0xFF721C24),
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
