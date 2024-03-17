import 'package:gemini_demo/core/enums/roles.dart';

class ChatMessage {
  String text;
  Roles role;
  ChatMessage({
    required this.text,
    required this.role,
  });
}
