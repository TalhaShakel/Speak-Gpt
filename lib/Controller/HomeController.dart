import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:convert';

class HomeController extends GetxController {
  bool isMic = false;
  isMicUser(val) {
    isMic = val;
    update();
  }

  String res = "";
  List chat = [];

  post(prompt) async {
    try {
      EasyLoading.show();
      // var url = Uri.https(
      //     "https://api.openai.com/v1/models/text-davinci-002/completions/");
      var response = await http.post(
        Uri.parse(
            'https://api.openai.com/v1/engines/text-davinci-002/completions'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          // "model": "text-davinci-002",
          "prompt": prompt,
          "temperature": 1,
          "max_tokens": 1000,
          "top_p": 0.3,
          "frequency_penalty": 0.5,
          "presence_penalty": 0
        }),
      );

      // Parse the response
      var responseJson = jsonDecode(response.body);
      print(responseJson.toString() + "response.body");
      var responseText = responseJson["choices"][0]["text"];

      // Update the UI

      res = responseText;

      update();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      Get.snackbar(e.toString(), "");
    }
  }
}
