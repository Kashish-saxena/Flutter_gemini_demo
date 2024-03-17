import 'dart:developer';
import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart';

class ApiRepository {
  final _gemini = Gemini.instance;

  Stream<String> sendStreamText(String text) {
    return _gemini
        .streamGenerateContent(text)
        .map((value) => value.output ?? "")
        .handleError((e) => log(e));
  }

  Future<String> sendText(String text) async {
    String val = await _gemini.text(text).then((value) {
      log("Parts>>>>>>>>>${value?.content?.parts}");
      log("Roles>>>>>>>>>${value?.content?.role}");
      return value?.output ?? "";
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
      return value?.content?.parts?.last.text ?? '';
    }).catchError((e) => "$e");
    return val;
  }
}