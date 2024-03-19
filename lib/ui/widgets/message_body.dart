import 'package:flutter/material.dart';

class MessageBody extends StatelessWidget {
  const MessageBody(
      {super.key,
      this.boxColor,
      this.textColor,
      required this.mainAxisAlignment,
      required this.widget,
      });
  final Color? boxColor;
  final Color? textColor;
 
  final MainAxisAlignment mainAxisAlignment;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.5,horizontal: 15.0,),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: widget,
            ),
          ),
        ],
      ),
    );
  }
}
