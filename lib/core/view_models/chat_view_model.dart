import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/models/chat_message_model.dart';
import 'package:gemini_demo/core/repositories/api_repository.dart';
import 'package:gemini_demo/core/view_models/base_model.dart';

class ChatViewModel extends BaseModel {
  List<ChatMessage> _messages = [];
  TextEditingController _messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Getters
  List<ChatMessage> get messages => _messages;
  TextEditingController get messageController => _messageController;
  ScrollController get controller => _controller;

  // Setters
  set messageController(TextEditingController controller) {
    _messageController = controller;
  }

  scrollMessages() {
    _controller.animateTo(
      _controller.position.maxScrollExtent + 50,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  sendMessage(String text) async {
    _messages.add(ChatMessage(text: text, role: Roles.user));
    scrollMessages();
    updateUI();

    if (text.isNotEmpty) {
      String msg = await ApiRepository().sendText(text);
      _messages.add(ChatMessage(text: msg, role: Roles.model));
      scrollMessages();
      updateUI();
      log(_messages.toString());
    }
  }

}
