import 'dart:io';

import 'package:gemini_demo/core/enums/roles.dart';

class TextAndImageModel {
  String text;
  File? image;
  Roles role;

  TextAndImageModel({
    required this.text,
    required this.role,
    this.image,
  });
}
