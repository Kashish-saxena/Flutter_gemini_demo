import 'package:flutter/material.dart';
import 'package:gemini_demo/ui/views/chat_screen.dart';

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

List<SectionItem> sections = [
  SectionItem(0, 'Text And Image', ChatScreen()),
  // SectionItem(1, 'Chat', StreamTextScreen()),
];
