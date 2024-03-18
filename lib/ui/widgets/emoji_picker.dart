import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
class EmojiPickerWidget extends StatelessWidget {
  const EmojiPickerWidget({super.key,required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return 

EmojiPicker(
  
    textEditingController: controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
    config: Config(
        height: 256,
        // : const Color(0xFFF2F2F2),
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
        // Issue: https://github.com/flutter/flutter/issues/28894
        emojiSizeMax: 28 *
        (foundation.defaultTargetPlatform == TargetPlatform.iOS
            ?  1.20
            :  1.0),
        ),
        swapCategoryAndBottomBar:  false,
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: const CategoryViewConfig(),
        bottomActionBarConfig: const BottomActionBarConfig(),
        searchViewConfig: const SearchViewConfig(),
    ),
);
  }
}