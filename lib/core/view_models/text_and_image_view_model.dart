import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/models/text_image_model.dart';
import 'package:gemini_demo/core/repositories/api_repository.dart';
import 'package:gemini_demo/core/view_models/base_model.dart';
import 'package:image_picker/image_picker.dart';

class TextImageViewModel extends BaseModel {
  List<TextAndImageModel> _messages = [];
  TextEditingController _messageController = TextEditingController();
  File? _imageFile;
  bool _isImageSelected = false;
  File? _sendImage;
  bool _showEmoji = false;

  // Getters
  List<TextAndImageModel> get messages => _messages;
  TextEditingController get messageController => _messageController;
  File? get imageFile => _imageFile;
  bool get isImageSelected => _isImageSelected;
  File? get sendImage => _sendImage;
  bool get showEmoji => _showEmoji;

  // Setters
  set messageController(TextEditingController controller) {
    _messageController = controller;
  }

  set imageFile(File? file) {
    _imageFile = file;
  }

  set isImageSelected(bool isSelected) {
    _isImageSelected = isSelected;
  }

  set sendImage(File? file) {
    _sendImage = file;
  }

  set showEmoji(bool show) {
    _showEmoji = show;
  }

  changeEmoji() {
    _showEmoji = !_showEmoji;
    updateUI();
  }

  pickImageFromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _isImageSelected = true;
        updateUI();
        return _imageFile;
      } else {
        log('User didnt pick any image.');
      }
      _imageFile = null;
    } catch (e) {
      log(e.toString());
    }
  }

  pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _isImageSelected = true;
        updateUI();
        return _imageFile;
      } else {
        log('User didnt pick any image.');
      }
      _imageFile = null;
    } catch (e) {
      log(e.toString());
    }
  }

  sendTextAndImageInfo() async {
    _sendImage = _imageFile;
    var msg = "";
    _messages.add(TextAndImageModel(
        text: _messageController.text, role: Roles.user, image: _sendImage));
    _imageFile = null;
    updateUI();
    _isImageSelected = false;
    if (_sendImage != null) {
      msg = await ApiRepository()
          .sendTextAndImage(_messageController.text, _sendImage ?? File(""));
      _messages.add(TextAndImageModel(
        role: Roles.model,
        text: msg,
      ));
    } else {
      msg = await ApiRepository().sendText(_messageController.text);
      _messages.add(TextAndImageModel(role: Roles.model, text: msg));
    }
    updateUI();
  }
}
