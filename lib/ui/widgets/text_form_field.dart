import 'package:flutter/material.dart';
import 'package:gemini_demo/core/constants/color_consant.dart';
import 'package:gemini_demo/core/constants/string_constant.dart';
import 'package:gemini_demo/core/view_models/chat_view_model.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({super.key, required this.model});
  final ChatViewModel? model;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        if (model?.showEmoji == true) {
          model?.changeEmoji();
        }
      },
      onEditingComplete: () {
        if (model?.messageController.text.toString().isNotEmpty ?? false) {
          model?.sendTextAndImageInfo();
          model?.messageController.clear();
        }
      },
      maxLines: 4,
      minLines: 1,
      keyboardAppearance: Brightness.light,
      cursorColor: ColorConstants.offWhite,
      style: const TextStyle(color: ColorConstants.white),
      controller: model?.messageController,
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: ColorConstants.offWhite),
        hintText: StringConstants.typeMessage,
        hintStyle: const TextStyle(color: ColorConstants.offWhite,fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0,horizontal: 10),
      ),
    );
  }
}
