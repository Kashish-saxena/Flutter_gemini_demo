import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_demo/core/enums/roles.dart';
import 'package:gemini_demo/core/enums/view_state.dart';
import 'package:gemini_demo/core/models/text_image_model.dart';
import 'package:gemini_demo/core/repositories/api_repository.dart';
import 'package:gemini_demo/core/view_models/base_model.dart';
import 'package:image_picker/image_picker.dart';

class ChatViewModel extends BaseModel {
  final ApiRepository apiRepository = ApiRepository();
  final TextEditingController messageController = TextEditingController();
  final ScrollController controller = ScrollController();

  late List<TextAndImageModel> _messages;
  File? _imageFile;
  File? _sendFile;
  bool _isImageSelected = false;
  bool _showEmoji = false;
  bool isTyping = false;
  int? loadingMessageIndex;

  List<TextAndImageModel> get messages => _messages;
  File? get imageFile => _imageFile;
  bool get isImageSelected => _isImageSelected;
  bool get showEmoji => _showEmoji;

  ChatViewModel() {
    _messages = [];
  }

  scrollMessages() {
    controller.animateTo(
      controller.position.maxScrollExtent + 40,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  changeEmoji() {
    _showEmoji = !_showEmoji;
    updateUI();
  }

  Future<void> sendTextAndImageInfo() async {
    int modelResponseIndex = messages.length;
    state = ViewState.busy;
    _sendFile = _imageFile;
    _messages.add(TextAndImageModel(
      text: messageController.text,
      role: Roles.user,
      image: _sendFile,
    ));
    state = ViewState.idle;
    isTyping = true;
    _imageFile = null;

    setLoadingMessageIndex(modelResponseIndex);
    scrollMessages();
    updateUI();
    _isImageSelected = false;
    state = ViewState.busy;
    String msg = _imageFile != null
        ? await apiRepository.sendTextAndImage(
            messageController.text, _sendFile ?? File(""))
        : await apiRepository.sendText(messageController.text);

    _messages.add(TextAndImageModel(
      role: Roles.model,
      text: msg,
    ));

    isTyping = false;
    state = ViewState.idle;
    setLoadingMessageIndex(null);
    scrollMessages();
    updateUI();
  }

  setLoadingMessageIndex(int? index) {
    loadingMessageIndex = index;
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
}
