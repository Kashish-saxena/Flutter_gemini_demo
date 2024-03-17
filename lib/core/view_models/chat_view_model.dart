import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/models/chat_message_model.dart';
import 'package:gemini_demo/core/repositories/api_repository.dart';
import 'package:gemini_demo/core/view_models/base_model.dart';

class ChatViewModel extends BaseModel {
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();

  sendMessage(String text) async {
    messages.add(ChatMessage(text: text, role: Roles.user));
    updateUI();
    String msg = await ApiRepository().sendText(text);
    messages.add(ChatMessage(text: msg, role: Roles.model));
    updateUI();
    log(messages.toString());
  }
}
