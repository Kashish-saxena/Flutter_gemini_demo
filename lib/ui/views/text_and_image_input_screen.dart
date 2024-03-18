import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_demo/core/constants/color_consant.dart';
import 'package:gemini_demo/core/constants/image_constants.dart';
import 'package:gemini_demo/core/constants/string_constant.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/models/text_image_model.dart';
import 'package:gemini_demo/core/routing/routes.dart';
import 'package:gemini_demo/core/view_models/text_and_image_view_model.dart';
import 'package:gemini_demo/ui/views/base_view.dart';
import 'package:gemini_demo/ui/views/chat_screen.dart';
import 'package:gemini_demo/ui/widgets/emoji_picker.dart';
import 'package:gemini_demo/ui/widgets/message_body.dart';

// ignore: must_be_immutable
class TextAndImageScreen extends StatelessWidget {
  TextAndImageScreen({super.key});

  TextImageViewModel? model;
  @override
  Widget build(BuildContext context) {
    return BaseView<TextImageViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: PopScope(
            canPop: true,
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: ColorConstants.black,
                body: buildBody(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: model?.messages.length,
            itemBuilder: (context, index) {
              TextAndImageModel? textAndImageModel;
              if (model?.messages != null) {
                textAndImageModel = model?.messages[index];
              }
              return textAndImageModel != null
                  ? _buildMessage(textAndImageModel, index)
                  : Container();
            },
          ),
        ),
        _buildInputField(context),
        if (model?.showEmoji == true)
          SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: EmojiPickerWidget(controller: model!.messageController))
      ],
    );
  }

  Widget _buildMessage(TextAndImageModel message, int index) {
    return MessageBody(
      widget: Column(
        crossAxisAlignment: message.role == Roles.user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          message.image != null
              ? Image(
                  height: 200,
                  image: FileImage(
                      message.image ?? File("assets/images/background.jpg")),
                )
              : const SizedBox(),
          Text(message.text),
        ],
      ),
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

  Widget _buildInputField(context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  model?.imageFile != null
                      ? TextField(
                        onTap: () {
                                  if (model?.showEmoji == true) {
                                    model?.changeEmoji();
                                  }
                                },
                          onEditingComplete: () {
                            if (model?.messageController.text
                                    .toString()
                                    .isNotEmpty ??
                                false) {
                              model?.sendTextAndImageInfo();
                              model?.messageController.clear();
                            }
                          },
                          controller: model?.messageController,
                          decoration: InputDecoration(
                            hintText: StringConstants.typeMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                          ),
                        )
                      : SizedBox(),
                  model?.imageFile != null
                      ? Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Image(
                            height: 200,
                            width: 200,
                            image: FileImage(
                                model?.imageFile ?? File(ImageConstants.demo)),
                          ),
                        )
                      : Container(),
                  const SizedBox(width: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      model?.imageFile == null
                          ? Flexible(
                              child: TextField(
                                onTap: () {
                                  if (model?.showEmoji == true) {
                                    model?.changeEmoji();
                                  }
                                },
                                onEditingComplete: () {
                                  if (model?.messageController.text
                                          .toString()
                                          .isNotEmpty ??
                                      false) {
                                    model?.sendTextAndImageInfo();
                                    model?.messageController.clear();
                                  }
                                },
                                controller: model?.messageController,
                                decoration: InputDecoration(
                                  hintText: StringConstants.typeMessage,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: ColorConstants.transparent,
                                context: context,
                                builder: (builder) =>
                                    buildFunctionality(context));
                          },
                          icon: const Icon(Icons.attach_file)),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            model?.changeEmoji();
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: ColorConstants.black,
                          )),
                      IconButton(
                        icon: const Icon(
                          Icons.camera,
                          color: ColorConstants.black,
                        ),
                        onPressed: () {
                          buildImagePicker(context);
                          FocusScope.of(context).unfocus();
                          model?.messageController.clear();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: ColorConstants.black,
                        ),
                        onPressed: () {
                          if (model?.messageController.text
                                  .toString()
                                  .isNotEmpty ??
                              false) {
                            model?.sendTextAndImageInfo();
                            model?.messageController.clear();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFunctionality(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildIconFunction(context, Icons.chat, "Chat",
                  () => Navigator.pushNamed(context, Routes.chatScreen)),
              buildIconFunction(context, Icons.stream, "Stream",
                  () => Navigator.pushNamed(context, Routes.chatScreen)),
              buildIconFunction(context, Icons.image_search_sharp, "Image",
                  () => Navigator.pushNamed(context, Routes.chatScreen)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconFunction(
      BuildContext context, IconData icon, String text, Function onTap) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(text),
        ],
      ),
    );
  }

  void buildImagePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: ColorConstants.black,
      context: context,
      builder: (builder) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .09,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => model?.pickImageFromCamera(),
                  child: const Icon(
                    Icons.camera_alt,
                    color: ColorConstants.white,
                    size: 35,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => model?.pickImageFromGallery(),
                  child: const Icon(
                    Icons.image_rounded,
                    color: ColorConstants.white,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
