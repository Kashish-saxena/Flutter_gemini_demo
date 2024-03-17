import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/models/text_image_model.dart';
import 'package:gemini_demo/core/repositories/api_repository.dart';
import 'package:gemini_demo/core/view_models/base_model.dart';
import 'package:image_picker/image_picker.dart';

class TextImageViewModel extends BaseModel {
  List<TextAndImageModel> messages = [];
  TextEditingController messageController = TextEditingController();
  File? imageFile;
  bool isImageSelected = false;

  pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
        isImageSelected = true;
        updateUI();
        return imageFile;
      } else {
        log('User didnt pick any image.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  sendTextAndImageInfo(text) async {
    messages
        .add(TextAndImageModel(text: text, role: Roles.user, image: imageFile));
    updateUI();
    isImageSelected = false;
    updateUI();
    var msg =
        await ApiRepository().sendTextAndImage(text, imageFile ?? File(""));
    messages
        .add(TextAndImageModel(role: Roles.model, text: msg, image: imageFile));
    updateUI();
  }
  
}
