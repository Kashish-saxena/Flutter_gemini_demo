import 'package:flutter/material.dart';
import 'package:gemini_demo/ui/views/chat_screen.dart';
import 'package:gemini_demo/ui/views/text_and_image_input_screen.dart';

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

List<SectionItem> sections = [
  SectionItem(0, 'Text And Image', TextAndImageScreen()),
  SectionItem(1, 'Chat', ChatScreen()),
];
