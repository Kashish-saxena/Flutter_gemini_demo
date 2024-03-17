import 'package:flutter/material.dart';
import 'package:gemini_demo/core/constants/color_consant.dart';
import 'package:gemini_demo/core/constants/string_constant.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/models/chat_message_model.dart';
import 'package:gemini_demo/core/view_models/chat_view_model.dart';
import 'package:gemini_demo/ui/views/base_view.dart';
import 'package:gemini_demo/ui/widgets/message_body.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  late ChatViewModel model;
  @override
  Widget build(BuildContext context) {
    return BaseView<ChatViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorConstants.black,
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: model.messages.length,
            itemBuilder: (context, index) {
              return _buildMessage(model.messages[index], index);
            },
          ),
        ),
        _buildInputField(),
      ],
    );
  }

  Widget _buildMessage(ChatMessage message, int index) {
    return MessageBody(
      text: message.text,
      mainAxisAlignment: message.role == Roles.user
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      boxColor: message.role == Roles.user
          ? ColorConstants.blue
          : ColorConstants.blueAccent,
      textColor: message.role == Roles.user
          ? ColorConstants.white
          : ColorConstants.black,
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: model.messageController,
              decoration: InputDecoration(
                hintText: StringConstants.typeMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: ColorConstants.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: ColorConstants.white,
            ),
            onPressed: () {
              model.sendMessage(model.messageController.text);
              model.messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
