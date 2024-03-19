import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini_demo/core/constants/color_consant.dart';
import 'package:gemini_demo/core/constants/image_constants.dart';
import 'package:gemini_demo/core/constants/string_constant.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/enums/view_state.dart';
import 'package:gemini_demo/core/models/text_image_model.dart';
import 'package:gemini_demo/core/view_models/chat_view_model.dart';
import 'package:gemini_demo/ui/views/base_view.dart';
import 'package:gemini_demo/ui/widgets/emoji_picker.dart';
import 'package:gemini_demo/ui/widgets/message_body.dart';
import 'package:gemini_demo/ui/widgets/text_form_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  ChatViewModel? model;
  @override
  Widget build(BuildContext context) {
    return BaseView<ChatViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstants.defaultWallpaper),
                ),
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: ColorConstants.transparent,
                appBar: AppBar(
                  toolbarHeight: 70,
                  leadingWidth: 60,
                  backgroundColor: ColorConstants.transparent,
                  leading: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 15, bottom: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(ImageConstants.logo, fit: BoxFit.fill),
                    ),
                  ),
                  title: const Text(
                    StringConstants.geminiDemo,
                    style: TextStyle(color: ColorConstants.white),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: ColorConstants.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
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
          physics: const AlwaysScrollableScrollPhysics(),
          controller: model?.controller,
          itemCount: model?.messages.length,
          itemBuilder: (context, index) {
            TextAndImageModel? textAndImageModel;
            int last = (model?.messages.length ?? 0);
            if (model?.messages != null) {
              textAndImageModel = model?.messages[index];

              log("Last index======>${model?.messages.length.toString() ?? ""}");
              log("current index=========>${index.toString()}");
            }
           
            return textAndImageModel != null
                ? _buildMessage(textAndImageModel, index, last)
                : Container();
          },
        ),
      ),
      _buildInputField(context),
      if (model?.showEmoji == true)
        SizedBox(
          height: MediaQuery.of(context).size.height * .35,
          child: EmojiPickerWidget(controller: model!.messageController),
        ),
    ],
  );
}

Widget _buildMessage(TextAndImageModel message, int index, int last) {
  final isLoading = index == model?.loadingMessageIndex;
  return MessageBody(
    widget: Column(
      crossAxisAlignment: message.role == Roles.user
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (message.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              height: 200,
              image: FileImage(message.image!),
            ),
          ),
        if (isLoading) 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LoadingAnimationWidget.waveDots(
              color: ColorConstants.white,
              size: 15,
            ),
          )
        else 
          Text(
            message.text,
            style: const TextStyle(
              color: ColorConstants.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    ),
    mainAxisAlignment: message.role == Roles.user
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    boxColor: message.role == Roles.user
        ? ColorConstants.lightGrey
        : ColorConstants.darkGrey,
  );
}



  Widget _buildInputField(context) {
    return Container(
      margin: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: ColorConstants.inputBoxColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  model?.imageFile != null
                      ? TextFormFieldWidget(
                          model: model,
                        )
                      : const SizedBox(),
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
                  // const SizedBox(width: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            model?.changeEmoji();
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: ColorConstants.offWhite,
                          )),
                      model?.imageFile == null
                          ? Flexible(
                              child: TextFormFieldWidget(
                              model: model,
                            ))
                          : const SizedBox(),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: ColorConstants.transparent,
                                context: context,
                                isScrollControlled: true,
                                builder: (builder) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: buildAttachmentPopUp(context)));
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: ColorConstants.offWhite,
                          )),
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: ColorConstants.offWhite,
                        ),
                        onPressed: () {
                          model?.pickImageFromCamera();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      model?.state == ViewState.busy
                          ? const Center(child: CircularProgressIndicator())
                          : IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: ColorConstants.offWhite,
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

  Widget buildAttachmentPopUp(context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 70),
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: ColorConstants.lightGrey,
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconFunction(context, Icons.image, "Gallery",
                  () => model?.pickImageFromGallery()),
              const SizedBox(
                width: 20,
              ),
              buildIconFunction(context, Icons.camera_alt, "Camera",
                  () => model?.pickImageFromCamera()),
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
            backgroundColor: ColorConstants.offWhite,
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(text,
              style: const TextStyle(
                color: ColorConstants.white,
              )),
        ],
      ),
    );
  }
}
