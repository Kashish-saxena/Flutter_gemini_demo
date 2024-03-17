import 'package:flutter/material.dart';

class MessageBody extends StatelessWidget {
  const MessageBody(
      {super.key,
      this.boxColor,
      this.textColor,
      required this.text,
      required this.mainAxisAlignment});
  final Color? boxColor;
  final Color? textColor;
  final String text;
  final MainAxisAlignment mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
