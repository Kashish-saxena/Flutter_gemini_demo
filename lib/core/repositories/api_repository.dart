import 'dart:developer';
import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart';

class ApiRepository {
  late Gemini _gemini;
  static final ApiRepository _instance = ApiRepository._internal();
  factory ApiRepository() {
    return _instance;
  }
  ApiRepository._internal() {
    _gemini = Gemini.instance;
  }

  Stream<String> sendStreamText(String text) {
    return _gemini
        .streamGenerateContent(text)
        .map((value) => value.output ?? "")
        .handleError((e) => log(e));
  }

  String? result;
  Future<String> sendText(String text) async {
    String val = await _gemini.text(text).then((value) {
      log("Parts>>>>>>>>>${value?.content?.parts}");
      log("Roles>>>>>>>>>${value?.content?.role}");
      result = value?.output ?? "";
      if (value?.finishReason != 'STOP') {
        result = "Sorry but I couldn't understand your query";
      }
      return result ?? "";
    }).catchError((e) => "$e");
    log(val);
    return val;
  }

  Future<String> sendTextAndImage(String text, File imageFile) async {
    String val = await _gemini.textAndImage(
      text: text,
      images: [imageFile.readAsBytesSync()],
    ).then((value) {
      log(value?.content?.parts?.last.text ?? '');
        log("Roles>>>>>>>>>${value?.content?.role}");
      result = value?.content?.parts?.last.text ?? '';
      if (value?.finishReason != 'STOP') {
        result = "Sorry but I couldn't understand your query";
      }
     
      return value?.content?.parts?.last.text ?? '';
    }).catchError((e) => "$e");
    return val;
  }
}
