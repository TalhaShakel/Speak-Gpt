import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:convert';

import 'package:speech_to_text/speech_to_text.dart';

class HomeController extends GetxController {
  SpeechToText speech = SpeechToText();
  var messageController = TextEditingController();

  bool isMic = false;
  bool isListening = false;

  // isMicUser(val) async {
  //   isMic = val;
  //   if (val == true) {}
  //   update();
  // }

  startRec() async {
    var available = await speech.initialize();
    if (available) {
      speech.listen(onResult: (_) {
        messageController.text = _.recognizedWords;
      });
      update();
    }
  }

  stopRec() {
    isMic = false;
    speech.stop();
    update();
  }

  String res = "";
  List chat = [];

  post(prompt) async {
    var apikey = "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";
    try {
      EasyLoading.show();
      // var url = Uri.https(
      //     "https://api.openai.com/v1/models/text-davinci-002/completions/");
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": prompt,
          "temperature": 1,
          "max_tokens": 1000,
          "top_p": 0.3,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0
        }),
      );

      // Parse the response
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body.toString());
        print(responseJson.toString() + "poka");
        var responseText = responseJson["choices"][0]["text"];

        // Update the UI

        res = responseText;
      }
      update();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      Get.snackbar(e.toString(), "");
    }
  }
}
